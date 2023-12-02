
### <b>aws.static<b>
Create and manage statically serving website through S3

- `type`: attribute set of submodules
- `default`: {}
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket<b>
Options to control bucket configuration.

- `type`: submodule
- `default`: null
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.arn<b>
Bucket Amazon Resource Name (known after apply)

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.description<b>
description to be attached to bucket resource.

- `type`: string
- `default`: &#34;{self.environment} {self.description} Bucket&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.domainName<b>
Bucket domainName pointing to the s3 bucket (known after apply)

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.iamPolicies<b>
IAM policy documents attached to bucket

- `type`: attribute set
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.id<b>
Bucket ID (known after apply)

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.name<b>
Bucket Name (set by default)

- `type`: string
- `default`: &#34;{name}-{environment}-static-files&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.objectOwnership<b>
- BucketOwnerPreferred  (default)
  Objects uploaded change ownership to the bucket owner if uploaded with ACL.
- ObjectWriter
  Uploading account will own the object if the object is uploaded.
- BucketOwnerEnforced
  Bucket owner automatically owns and has control over every object in the bucket.


- `type`: string
- `default`: &#34;BucketOwnerPreferred&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.region<b>
Bucket Region (known after apply)

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.resource<b>
A reference pointing to the s3 bucket

- `type`: anything
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.bucket.withVersioning<b>
Whether bucket versioning should be enabled.
See: https://docs.aws.amazon.com/AmazonS3/latest/userguide/manage-versioning-examples.html


- `type`: boolean
- `default`: false
- `example`: null


### <b>aws.static.&lt;name&gt;.description<b>
description of the static site.

- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.static.&lt;name&gt;.distribution<b>
Options related to distributing the bucket content

- `type`: attribute set of submodules
- `default`: {}
- `example`: null


### <b>aws.static.&lt;name&gt;.distribution.&lt;name&gt;.accessIdentity<b>
AWS Resource Name (arn) to be used to configure s3 access policies


- `type`: string
- `default`: null
- `example`: null


### <b>aws.static.&lt;name&gt;.distribution.&lt;name&gt;.name<b>
Name of the distribution

- `type`: string
- `default`: &#34;‹name›&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.environment<b>
environment name

- `type`: string
- `default`: &#34;playground&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.name<b>
name of the static website.

- `type`: string
- `default`: &#34;‹name›&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.resourceKey<b>
Resource Key (set by default).

- `type`: string
- `default`: &#34;{name}_{environment}_static&#34;
- `example`: null


### <b>aws.static.&lt;name&gt;.tags<b>
Resource tags to be attached some aws resources.

- `type`: attribute set
- `default`: &#34;{ Product: {self.name}, Environment = {self.environment} }&#34;
- `example`: null

