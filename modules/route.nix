{ lib, config, ... }:
with lib;
with types;
let
  cfg = config.aws.route;
  concatMapCfg = f: concatMapAttrs (key: o: (f key o)) cfg;
in {
  options.aws.route = mkOption {
    description = "Create and Manage Route53 zones, records as well as certifications.";
    default = { };
    type = attrsOf (submodule ({ name, ... }:
      let
        routeName = name;
        self = cfg.${name};
      in {
        options = {
          name = mkOption {
            description = "The name of the hosted zone aka domain name";
            type = str;
            example = "example.com";
          };

          comment = mkOption {
            description = "A comment for the hosted zone";
            type = nullOr str;
            example = "Do Not Edit Manually!";
            default = "Managed";
          };

          delegationSetId = mkOption {
            description = ''
              The ID of the reusable delegation set whose NS records you want to assign to the hosted zone.
              Conflicts with vpc as delegation sets can only be used for public zones.
            '';
            type = nullOr str;
            default = null;
          };

          forceDestroy = mkOption {
            description = ''
              Whether to destroy all records in the route's zone on destriuction.
            '';
            type = bool;
            default = false;
          };

          tags = mkOption {
            description = ''
              A map of tags to assign to all aws resource accepting tags.
            '';
            type = attrs;
            default = null;
          };

          vpc = mkOption {
            description = ''
              Configuration block(s) specifying VPC(s) to associate with a private hosted zone.
              Conflicts with the delegation_set_id argument in this resource and any aws_route53_zone_association
              resource specifying the same zone ID. Detailed below.
            '';
            type = nullOr (listOf (submodule {
              options = {
                id = mkOption {
                  description = ''
                    ID of the VPC to associate.
                  '';
                  type = str;
                  default = "";
                };
                region = mkOption {
                  description = ''
                    Region of the VPC to associate. Defaults to AWS provider region.
                  '';
                  type = nullOr str;
                  default = null;
                };
              };
            }));
            default = null;
          };

          zone = mkOption {
            description = "aws resource zone";
            default = { };
            defaultText = "(known after apply)";
            type = submodule {
              options = {
                arn = mkOption {
                  description = "The amazon resource name of the hosted zone";
                  type = str;
                  defaultText = "(known after apply)";
                  default = config.resource.aws_route53_zone.${name} "arn";
                };
                id = mkOption {
                  description = "The Hosted Zone ID, usually referenced by zone records";
                  type = str;
                  defaultText = "(known after apply)";
                  default = config.resource.aws_route53_zone.${name} "zone_id";
                };
                nameServers = mkOption {
                  description = ''
                    A list of name servers in associated (or default) delegation set.
                    Find more about delegation sets in [AWS docs](https://docs.aws.amazon.com/Route53/latest/APIReference/actions-on-reusable-delegation-sets.html).
                  '';
                  type = str;
                  defaultText = "(known after apply)";
                  default = config.resource.aws_route53_zone.${name} "name_servers";
                };
                primaryNameServer = mkOption {
                  description = ''
                    The Route 53 name server that created the SOA record.
                  '';
                  type = str;
                  defaultText = "(known after apply)";
                  default =
                    config.resource.aws_route53_zone.${name} "primary_name_server";
                };
              };
            };
          };

          records = mkOption {
            description = "Create and manage aws resource record set";
            default = [ ];
            type = attrsOf (submodule ({ name, ... }: {
              options = {
                name = mkOption {
                  description = ''
                    The name of the record.
                  '';
                  type = str;
                  default = name;
                };
                key = mkOption {
                  description = ''
                    key to access resource (set by default)
                  '';
                  defaultText = "{routeName}_{recordName}";
                  default = "${routeName}_${name}";
                };
                fqdn = mkOption {
                  description = ''
                    [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) built using the zone domain and name
                  '';
                  defaultText = "(known after apply)";
                  default =
                    config.resource.aws_route53_record.${self.records.${name}.name} "";
                };
                zoneId = mkOption {
                  description = ''
                    The ID of the hosted zone to contain this record.
                  '';
                  type = str;
                  defaultText = "aws.route.‹name›.zone.id";
                  default = self.zone.id;
                };
                type = mkOption {
                  description = ''
                    The record type.
                  '';
                  type = enum [
                    "A"
                    "AAAA"
                    "CAA"
                    "CNAME"
                    "DS"
                    "MX"
                    "NAPTR"
                    "NS"
                    "PTR"
                    "SOA"
                    "SPF"
                    "SRV"
                    "TXT"
                  ];
                  example = "A";
                };
                ttl = mkOption {
                  description = ''
                    The TTL of the record.
                  '';
                  type = nullOr str;
                  default = null;
                  example = "300";
                };
                value = mkOption {
                  description = ''
                    A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM
                  '';
                  type = nullOr (either (listOf str) str);
                  default = null;
                };
                setIdentifier = mkOption {
                  description = ''
                    Unique identifier to differentiate records with routing policies from one another.
                    Required if using cidr_routing_policy, failover_routing_policy, geolocation_routing_policy,
                    latency_routing_policy, multivalue_answer_routing_policy, or weighted_routing_policy.
                  '';
                  type = nullOr str;
                  default = null;
                };
                healthCheckId = mkOption {
                  description = ''
                    The health check the record should be associated with.
                  '';
                  type = nullOr str;
                  default = null;
                };
                alias = mkOption {
                  description = ''
                    An alias block. Conflicts with ttl & records.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                cidrRoutingPolicy = mkOption {
                  description = ''
                    A block indicating a routing policy based on the IP network ranges of requestors.
                    Conflicts with any other routing policy. Documented below.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                failoverRoutingPolicy = mkOption {
                  description = ''
                    A block indicating the routing behavior when associated health check fails.
                    Conflicts with any other routing policy. Documented below.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                geolocationRoutingPolicy = mkOption {
                  description = ''
                    A block indicating a routing policy based on the geolocation of the requestor.
                    Conflicts with any other routing policy. Documented below.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                latencyRoutingPolicy = mkOption {
                  description = ''
                    A block indicating a routing policy based on the latency between the requestor and an AWS region.
                    Conflicts with any other routing policy. Documented below.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                multivalueAnswerRoutingPolicy = mkOption {
                  description = ''
                    Set to true to indicate a multivalue answer routing policy.
                    Conflicts with any other routing policy.
                  '';
                  type = nullOr bool;
                  default = null;
                };
                weightedRoutingPolicy = mkOption {
                  description = ''
                    A block indicating a weighted routing policy. Conflicts with any other routing policy. Documented below.
                  '';
                  type = nullOr (attrsOf str);
                  default = null;
                };
                allowOverwrite = mkOption {
                  description = ''
                    Allow creation of this record in Terraform to overwrite an existing record, if any.
                    This does not affect the ability to update the record in Terraform and does not prevent
                    other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
                    false by default. This configuration is not recommended for most environments.
                  '';
                  type = bool;
                  default = false;
                };
              };
            }));
          };

          certificate = mkOption {
            description = ''
              Create and Manage Route53 zones, records as well as certifications.
            '';
            default = { };
            type = submodule {
              options = {
                enable = mkOption {
                  description = "Whether to enable certificate submodule";
                  type = bool;
                  default = false;
                };

                domainName = mkOption {
                  description = ''
                    Domain name for which the certificate should be issued
                  '';
                  type = str;
                  default = self.name;
                  defaultText = "aws.route.‹name›.name";
                };

                recordTTL = mkOption {
                  description = ''
                    The TTL of cert records.
                  '';
                  type = nullOr int;
                  default = null;
                  example = "300";
                };

                recordAllowOverwrite = mkOption {
                  description = ''
                    Allow creation of this record in Terraform to overwrite an existing record, if any.
                    This does not affect the ability to update the record in Terraform and does not prevent
                    other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
                    false by default. This configuration is not recommended for most environments.

                  '';
                  type = nullOr bool;
                  default = null;
                };

                alternativeNames = mkOption {
                  description = ''
                    Set of domains that should be SANs in the issued certificate.
                    To remove all elements of a previously configured list, set this value equal to an empty list ([])
                  '';
                  type = nullOr (listOf str);
                  default = null;
                  example = [ "www.example.com" "api.example.com" ];
                };

                validationMethod = mkOption {
                  description = ''
                    Which method to use for validation. DNS or EMAIL are valid.
                    NOTE: ONLY DNS Supported.
                  '';
                  type = enum [ "DNS" "EMAIL" ];
                  example = "DNS";
                };

                algorithm = mkOption {
                  description = ''
                    Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data.
                    See [Key Algorithms](https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate.html#algorithms.title)
                  '';
                  type = nullOr str;
                  default = null;
                };

                options = mkOption {
                  description = ''
                    Configuration block used to set certificate options.
                  '';
                  default = null;
                  type = nullOr (submodule {
                    options = {
                      transparencyLogging = mkOption {
                        description = ''
                          Whether certificate details should be added to a certificate transparency log.
                          See [ACM Transparency](https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency) for more details.
                        '';
                        type = nullOr (enum [ "ENABLED" "DISABLED" ]);
                        default = null;
                      };
                    };
                  });
                };

                resource = mkOption {
                  description = "Reference to AWS certificate resource";
                  type = anything;
                  default = config.resource.aws_acm_certificate.${name};
                  defaultText = "(known after apply)";
                };

                id = mkOption {
                  description = "ARN of the certificate";
                  type = str;
                  default = self.certificate.resource "id";
                  defaultText = "(known after apply)";
                };

                arn = mkOption {
                  description = "ARN of the certificate";
                  type = str;
                  default = self.certificate.resource "arn";
                  defaultText = "(known after apply)";
                };

                domainValidationOptions = mkOption {
                  description = ''
                    Set of domain validation objects which can be used to complete certificate validation.
                    Can have more than one element, e.g., if SANs are defined. Only set if DNS-validation was used.
                  '';
                  type = str;
                  default = self.certificate.resource "domain_validation_options";
                  defaultText = "(known after apply)";
                };

                status = mkOption {
                  description = ''
                    Status of the certificate.
                  '';
                  type = str;
                  default = self.certificate.resource "status";
                  defaultText = "(known after apply)";
                };
              };
            };
          };
        };
      }));
  };

  config = mkIf (cfg != { }) {
    resource = concatMapCfg (key: opts: {
      aws_route53_zone.${key} = {
        inherit (opts) tags name comment;
        delegation_set_id = opts.delegationSetId;
        force_destroy = opts.forceDestroy;
        vpc = mkIf (opts.vpc != null) (map (v: {
          vpc_id = v.id;
          vpc_region = v.region;
        }) opts.vpc);
      };

      aws_route53_record = mkMerge [
        (mapAttrs' (_: o:
          nameValuePair o.key {
            inherit (o) name type ttl alias;
            zone_id = o.zoneId;
            records = o.value;
            set_identifier = o.setIdentifier;
            health_check_id = o.healthCheckId;
            cidr_routing_policy = o.cidrRoutingPolicy;
            failover_routing_policy = o.failoverRoutingPolicy;
            geolocation_routing_policy = o.geolocationRoutingPolicy;
            latency_routing_policy = o.latencyRoutingPolicy;
            multivalue_answer_routing_policy = o.multivalueAnswerRoutingPolicy;
            weighted_routing_policy = o.weightedRoutingPolicy;
            allow_overwrite = o.allowOverwrite;
          }) opts.records)
        (mkIf opts.certificate.enable {
          "${key}_cert" = {
            zone_id = opts.zone.id;
            for_each = let certificate = "aws_acm_certificate.${key}";
            in ''
              ''${{for dvo in ${certificate}.domain_validation_options : dvo.domain_name  => {
                    name    = dvo.resource_record_name
                    record  = dvo.resource_record_value
                    type    = dvo.resource_record_type
                  }
                }}'';
            allow_overwrite = opts.certificate.recordAllowOverwrite;
            name = "\${each.value.name}";
            type = "\${each.value.type}";
            records = [ "\${each.value.record}" ];
            ttl = opts.certificate.recordTTL;
          };
        })
      ];

      aws_acm_certificate_validation.${key} = mkIf opts.certificate.enable {
        certificate_arn = opts.certificate.arn;
        validation_record_fqdns =
          "\${[for record in aws_route53_record.${key}_cert : record.fqdn]}";
      };

      aws_acm_certificate.${key} = mkIf opts.certificate.enable {
        inherit (opts) tags;
        domain_name = opts.certificate.domainName;
        subject_alternative_names = opts.certificate.alternativeNames;
        validation_method = opts.certificate.validationMethod;
        key_algorithm = opts.certificate.algorithm;
        options = mkIf (opts.certificate.options != null) {
          certificate_transparency_logging_preference =
            opts.certificate.options.transparencyLogging;
        };
      };
    });
  };
}
