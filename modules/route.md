
### <b>aws.route<b>
Create and Manage Route53 zones, records as well as certifications.

- `type`: attribute set of submodules
- `default`: {}
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate<b>
Create and Manage Route53 zones, records as well as certifications.


- `type`: submodule
- `default`: {}
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.algorithm<b>
Specifies the algorithm of the public and private key pair that your Amazon issued certificate uses to encrypt data.
See [Key Algorithms](https://docs.aws.amazon.com/acm/latest/userguide/acm-certificate.html#algorithms.title)


- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.alternativeNames<b>
Set of domains that should be SANs in the issued certificate.
To remove all elements of a previously configured list, set this value equal to an empty list ([])


- `type`: null or list of strings
- `default`: null
- `example`: [&#34;www.example.com&#34;,&#34;api.example.com&#34;]


### <b>aws.route.&lt;name&gt;.certificate.arn<b>
ARN of the certificate

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.domainName<b>
Domain name for which the certificate should be issued


- `type`: string
- `default`: &#34;aws.route.‹name›.name&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.domainValidationOptions<b>
Set of domain validation objects which can be used to complete certificate validation.
Can have more than one element, e.g., if SANs are defined. Only set if DNS-validation was used.


- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.enable<b>
Whether to enable certificate submodule

- `type`: boolean
- `default`: false
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.id<b>
ARN of the certificate

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.options<b>
Configuration block used to set certificate options.


- `type`: null or submodule
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.options.transparencyLogging<b>
Whether certificate details should be added to a certificate transparency log.
See [ACM Transparency](https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency) for more details.


- `type`: null or one of &#34;ENABLED&#34;, &#34;DISABLED&#34;
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.recordAllowOverwrite<b>
Allow creation of this record in Terraform to overwrite an existing record, if any.
This does not affect the ability to update the record in Terraform and does not prevent
other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
false by default. This configuration is not recommended for most environments.



- `type`: null or boolean
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.recordTTL<b>
The TTL of cert records.


- `type`: null or signed integer
- `default`: null
- `example`: &#34;300&#34;


### <b>aws.route.&lt;name&gt;.certificate.resource<b>
Reference to AWS certificate resource

- `type`: anything
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.status<b>
Status of the certificate.


- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.certificate.validationMethod<b>
Which method to use for validation. DNS or EMAIL are valid.
NOTE: ONLY DNS Supported.


- `type`: one of &#34;DNS&#34;, &#34;EMAIL&#34;
- `default`: null
- `example`: &#34;DNS&#34;


### <b>aws.route.&lt;name&gt;.comment<b>
A comment for the hosted zone

- `type`: null or string
- `default`: &#34;Managed&#34;
- `example`: &#34;Do Not Edit Manually!&#34;


### <b>aws.route.&lt;name&gt;.delegationSetId<b>
The ID of the reusable delegation set whose NS records you want to assign to the hosted zone.
Conflicts with vpc as delegation sets can only be used for public zones.


- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.forceDestroy<b>
Whether to destroy all records in the route&#39;s zone on destriuction.


- `type`: boolean
- `default`: false
- `example`: null


### <b>aws.route.&lt;name&gt;.name<b>
The name of the hosted zone aka domain name

- `type`: string
- `default`: null
- `example`: &#34;example.com&#34;


### <b>aws.route.&lt;name&gt;.records<b>
Create and manage aws resource record set

- `type`: attribute set of submodules
- `default`: []
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.alias<b>
An alias block. Conflicts with ttl &amp; records.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.allowOverwrite<b>
Allow creation of this record in Terraform to overwrite an existing record, if any.
This does not affect the ability to update the record in Terraform and does not prevent
other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record.
false by default. This configuration is not recommended for most environments.


- `type`: boolean
- `default`: false
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.cidrRoutingPolicy<b>
A block indicating a routing policy based on the IP network ranges of requestors.
Conflicts with any other routing policy. Documented below.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.failoverRoutingPolicy<b>
A block indicating the routing behavior when associated health check fails.
Conflicts with any other routing policy. Documented below.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.fqdn<b>
[FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name) built using the zone domain and name


- `type`: unspecified
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.geolocationRoutingPolicy<b>
A block indicating a routing policy based on the geolocation of the requestor.
Conflicts with any other routing policy. Documented below.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.healthCheckId<b>
The health check the record should be associated with.


- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.key<b>
key to access resource (set by default)


- `type`: unspecified
- `default`: &#34;{routeName}_{recordName}&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.latencyRoutingPolicy<b>
A block indicating a routing policy based on the latency between the requestor and an AWS region.
Conflicts with any other routing policy. Documented below.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.multivalueAnswerRoutingPolicy<b>
Set to true to indicate a multivalue answer routing policy.
Conflicts with any other routing policy.


- `type`: null or boolean
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.name<b>
The name of the record.


- `type`: string
- `default`: &#34;‹name›&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.setIdentifier<b>
Unique identifier to differentiate records with routing policies from one another.
Required if using cidr_routing_policy, failover_routing_policy, geolocation_routing_policy,
latency_routing_policy, multivalue_answer_routing_policy, or weighted_routing_policy.


- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.ttl<b>
The TTL of the record.


- `type`: null or string
- `default`: null
- `example`: &#34;300&#34;


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.type<b>
The record type.


- `type`: one of &#34;A&#34;, &#34;AAAA&#34;, &#34;CAA&#34;, &#34;CNAME&#34;, &#34;DS&#34;, &#34;MX&#34;, &#34;NAPTR&#34;, &#34;NS&#34;, &#34;PTR&#34;, &#34;SOA&#34;, &#34;SPF&#34;, &#34;SRV&#34;, &#34;TXT&#34;
- `default`: null
- `example`: &#34;A&#34;


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.value<b>
A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM


- `type`: null or list of strings or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.weightedRoutingPolicy<b>
A block indicating a weighted routing policy. Conflicts with any other routing policy. Documented below.


- `type`: null or attribute set of strings
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.records.&lt;name&gt;.zoneId<b>
The ID of the hosted zone to contain this record.


- `type`: string
- `default`: &#34;aws.route.‹name›.zone.id&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.tags<b>
A map of tags to assign to all aws resource accepting tags.


- `type`: attribute set
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.vpc<b>
Configuration block(s) specifying VPC(s) to associate with a private hosted zone.
Conflicts with the delegation_set_id argument in this resource and any aws_route53_zone_association
resource specifying the same zone ID. Detailed below.


- `type`: null or list of submodules
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.vpc.*.id<b>
ID of the VPC to associate.


- `type`: string
- `default`: &#34;&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.vpc.*.region<b>
Region of the VPC to associate. Defaults to AWS provider region.


- `type`: null or string
- `default`: null
- `example`: null


### <b>aws.route.&lt;name&gt;.zone<b>
aws resource zone

- `type`: submodule
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.zone.arn<b>
The amazon resource name of the hosted zone

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.zone.id<b>
The Hosted Zone ID, usually referenced by zone records

- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.zone.nameServers<b>
A list of name servers in associated (or default) delegation set.
Find more about delegation sets in [AWS docs](https://docs.aws.amazon.com/Route53/latest/APIReference/actions-on-reusable-delegation-sets.html).


- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null


### <b>aws.route.&lt;name&gt;.zone.primaryNameServer<b>
The Route 53 name server that created the SOA record.


- `type`: string
- `default`: &#34;(known after apply)&#34;
- `example`: null

