{ config, lib, ... }:
with lib;
with types;
let
  cfg = config.aws.static;
  mapCfg = f: mapAttrs' (_: o: nameValuePair o.resourceKey (f o)) cfg;
  concatMapCfg = f: concatMapAttrs (_: o: (f o)) cfg;

in {
  options = {
    aws.static = mkOption {
      description = "Create and manage statically serving website through S3";
      default = { };
      type = attrsOf (submodule ({ name, ... }:
        let self = cfg.${name};
        in {
          options = {
            name = mkOption {
              description = "name of the static website.";
              type = str;
              default = name;
            };

            description = mkOption {
              description = "description of the static site.";
              type = nullOr str;
              default = null;
            };

            environment = mkOption {
              description = "environment name";
              type = str;
              default = "playground";
            };

            resourceKey = mkOption {
              description = "Resource Key (set by default).";
              type = str;
              defaultText = "{name}_{environment}_static";
              default = "${name}_${toLower self.environment}_static";
            };

            bucket = mkOption {
              description = "Options to control bucket configuration.";
              type = submodule (_: {
                options = {
                  name = mkOption {
                    description = "Bucket Name (set by default)";
                    type = str;
                    defaultText = "{name}-{environment}-static-files";
                    default = "${name}-${toLower self.environment}-static-files";
                  };
                  description = mkOption {
                    description = "description to be attached to bucket resource.";
                    type = str;
                    defaultText = "{self.environment} {self.description} Bucket";
                    default = "${self.environment} ${self.description} Bucket";
                  };
                  id = mkOption {
                    description = "Bucket ID (known after apply)";
                    type = str;
                    defaultText = "(known after apply)";
                    default = self.bucket.resource "id";
                  };
                  arn = mkOption {
                    description = "Bucket Amazon Resource Name (known after apply)";
                    type = str;
                    defaultText = "(known after apply)";
                    default = self.bucket.resource "arn";
                  };
                  domainName = mkOption {
                    description =
                      "Bucket domainName pointing to the s3 bucket (known after apply)";
                    type = str;
                    defaultText = "(known after apply)";
                    default = self.bucket.resource "bucket_regional_domain_name";
                  };
                  region = mkOption {
                    description = "Bucket Region (known after apply)";
                    type = str;
                    defaultText = "(known after apply)";
                    default = self.bucket.resource "region";
                  };
                  withVersioning = mkOption {
                    description = ''
                      Whether bucket versioning should be enabled.
                      See: https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html
                    '';
                    type = bool;
                    default = false;
                  };
                  iamPolicies = mkOption {
                    description = "IAM policy documents attached to bucket";
                    type = attrs;
                    default = mapAttrs' (_: distOpts:
                      let
                        key = "${self.resourceKey}_${distOpts.name}";
                        resource = config.data.aws_iam_policy_document.${key};
                      in nameValuePair key resource) self.distribution;
                    defaultText = "(known after apply)";
                  };
                  objectOwnership = mkOption {
                    description = ''
                      - BucketOwnerPreferred  (default)
                        Objects uploaded change ownership to the bucket owner if uploaded with ACL.
                      - ObjectWriter
                        Uploading account will own the object if the object is uploaded.
                      - BucketOwnerEnforced
                        Bucket owner automatically owns and has control over every object in the bucket.
                    '';
                    type = str;
                    default = "BucketOwnerPreferred";
                  };
                  resource = mkOption {
                    description = "A reference pointing to the s3 bucket";
                    type = anything;
                    default = config.resource.aws_s3_bucket.${self.resourceKey};
                    defaultText = "(known after apply)";
                  };

                };
              });
            };

            distribution = mkOption {
              description = "Options related to distributing the bucket content";
              default = { };
              type = attrsOf (submodule ({ name, ... }: {
                options = {
                  name = mkOption {
                    description = "Name of the distribution";
                    type = str;
                    default = name;
                  };
                  accessIdentity = mkOption {
                    type = str;
                    description = ''
                      AWS Resource Name (arn) to be used to configure s3 access policies
                    '';
                    default = null;
                  };
                };
              }));
            };

            tags = mkOption {
              description = "Resource tags to be attached some aws resources.";
              type = attrs;
              defaultText = "{ Product: {self.name}, Environment = {self.environment} }";
              default = {
                Product = name;
                Environment = self.environment;
              };
            };
          };
        }));
    };
  };

  config = mkIf (cfg != { }) {
    resource = {
      aws_s3_bucket = mapCfg (opts: {
        bucket = opts.bucket.name;
        tags = opts.tags // { Description = opts.bucket.description; };
      });

      aws_s3_bucket_versioning = mapCfg (opts: {
        bucket = opts.bucket.id;
        versioning_configuration =
          [{ status = if opts.bucket.withVersioning then "Enabled" else "Disabled"; }];
      });

      aws_s3_bucket_ownership_controls = mapCfg (opts: {
        bucket = opts.bucket.id;
        rule = [{ object_ownership = opts.bucket.objectOwnership; }];
      });

      aws_s3_bucket_acl = mapCfg (opts: {
        bucket = opts.bucket.id;
        acl = "private";
        depends_on = [ "aws_s3_bucket_ownership_controls.${opts.resourceKey}" ];
      });

      aws_s3_bucket_policy = concatMapCfg (opts:
        mapAttrs (_: resource: {
          bucket = opts.bucket.id;
          policy = resource "json";
        }) opts.bucket.iamPolicies);
    };

    data = {
      aws_iam_policy_document = concatMapCfg (opts:
        mapAttrs' (_: distOpts:
          nameValuePair "${opts.resourceKey}_${distOpts.name}" {
            statement = [
              {
                actions = [ "s3:GetObject" ];
                resources = [ "${opts.bucket.arn}/*" ];
                principals = [{
                  identifiers = [ distOpts.accessIdentity ];
                  type = "AWS";
                }];
              }
              {
                actions = [ "s3:ListBucket" ];
                resources = [ opts.bucket.arn ];
                principals = [{
                  identifiers = [ distOpts.accessIdentity ];
                  type = "AWS";
                }];
              }
            ];
          }) opts.distribution);

    };

    output = concatMapCfg (opts: {
      "${opts.resourceKey}_bucket_id".value = opts.bucket.id;
      "${opts.resourceKey}_bucket_arn".value = opts.bucket.arn;
      "${opts.resourceKey}_bucket_domain_name".value = opts.bucket.domainName;
      "${opts.resourceKey}_bucket_region".value = opts.bucket.region;
    });
  };
}
