# Sample Terraform Modules

Make sure to setup the following 
<pre>
Johns-MacBook-Pro:s3 admin$ export AWS_ACCESS_KEY_ID="AKIAI7EY5GXTO5*****"
Johns-MacBook-Pro:s3 admin$ export AWS_SECRET_ACCESS_KEY="JKuTK507ieF3rHHbm65cA8eoEQ9n6Sj*****"
Johns-MacBook-Pro:s3 admin$ export AWS_DEFAULT_REGION="us-east-1"
Johns-MacBook-Pro:s3 admin$ terraform plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_s3_bucket.bucket
    acceleration_status: "<computed>"
    acl:                 "private"
    arn:                 "<computed>"
    bucket:              "rental-service-api-v1"
    bucket_domain_name:  "<computed>"
    force_destroy:       "false"
    hosted_zone_id:      "<computed>"
    region:              "<computed>"
    request_payer:       "<computed>"
    tags.%:              "2"
    tags.Environment:    "Dev"
    tags.Name:           "My bucket"
    versioning.#:        "<computed>"
    website_domain:      "<computed>"
    website_endpoint:    "<computed>"


Plan: 1 to add, 0 to change, 0 to destroy.
Johns-MacBook-Pro:s3 admin$ 
</pre>
