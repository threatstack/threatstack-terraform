# tf_threatstack_control_plane_monitoring_integration
Setup Threat Stack <-> Control Plane Monitoring integration module

This module provides the ability to define the Threat Stack integration infrastructure via Terraform.  Currently only AWS Cloudtrail is supported, and it automates the [AWS Manual Integration Setup](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup)

This module will create and manage the following:

* AWS CloudTrail
  * multi-region trail
  * records global service events
  * S3 bucket to store events
    * enables log file validation
  * CloudTrail to Cloudwatch logging
* AWS SNS topic to forward CloudTrail events to
* AWS SQS queue Threat Stack will check for events
* Cross account IAM role for Threat Stack


## Usage
> This version of the module is compatible with Terraform 0.12+.  Terraform 0.11 and earlier are not supported, and this module will not work. For a pre-0.12-compatible version of this module, see [v1.0.0 of this module](https://github.com/threatstack/threatstack-terraform/tree/v1.0.0).

To use this module you need to create a Terraform configuration that utilizes this module.  The minimum configuration would look as follows (Be sure to adjust the git ref in the source value appropriately):

```hcl
module "threatstack_aws_integration" {
  source                        = "github.com/threatstack/tf_threatstack_aws_integration?ref=<integration_version>"

  threatstack = {
    account_id        = "<THREATSTACK_AWS_ACCOUNT_ID>"
    external_id       = "<THREATSTACK_AWS_EXTERNAL_ID>"
  }

  aws         = {
    account_name      = "<AWS_ACCOUNT_NAME>"
    account_id        = "<AWS_ACCOUNT_ID>"
    region            = "us-east-1"
}
```

## Threat Stack Setup

In Threat Stack click `Add Account` under _AWS Accounts_ fill in the relevant output values on the _Integrations_ page under _Settings_ and get the Threat Stack _Account ID_ and _External ID_.  Use these values for the `threatstack.account_id` and `threatstack.external_id` input variables (see below).  Run Terraform and get the outputs from it.

![Terraform output](https://github.com/threatstack/tf_threatstack_aws_integration/raw/master/doc/terraform_output.png "Terraform output")

Record the Terraform output values, and use them to complete the configuration of the Threat Stack platform's side integration.  See sections 3 & 6 of the [AWS Manual Integration Setup](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup) page for details.

## Variables

There are two main Terraform input variable objects.  One is for Threat Stack-specific configuration settings, and the other is for AWS-specific configuration.

#### Threat Stack configuration

All of the Threat Stack configuration is required.  Not explicitly defining these values when using this module will cause the integration to not work as expected.

The Threat Stack configuration is defined as follows:

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/tf_threatstack_aws_integration?ref=<integration_version>"

  # Strings generated from the Threat Stack Add Account page
  threatstack = {

    account_id  = string 
    external_id = string

  }
}
```

* ___threatstack.account_id:___ Threat Stack account ID associated with the Threat Stack org.  Used to find remote state information and is prepended to bucket names.

* ___threatstack.external_id:___ Account ID, used for CloudTrail integration.


#### AWS configuration

This Terrform input variable is split into 3 sections: required settings, flag settings, and optional settings

##### Required settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/tf_threatstack_aws_integration?ref=<integration_version>"

  aws = {

    # ...

    account_name = string
    account_id   = string
    region       = string

    #...

  }
}
```

* ___aws.account_name:___ Name of AWS account.  Used to find remote state information and is prepended to bucket names.

* ___aws.account_id:___ Account ID, used for CloudTrail integration.

* ___aws.region:___ AWS region.  Used to find remote state.

##### Flag settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/tf_threatstack_aws_integration?ref=<integration_version>"

  aws = {

    # ...

    enable_logging                = boolean # Defaults to `true`
    enable_log_file_validation    = boolean # Defaults to `true`
    include_global_service_events = boolwan # Defaults to `true`
    is_multi_region_trail         = boolean # Defaults to `true`
    s3_force_destroy              = boolean # Defaults to `false`
    
    #...

  }
}

```
* ___aws.enable_logging (optional):___ Enable logging, set to 'false' to pause logging.

* ___aws.enable_log_file_validation (optional):___ Create signed digest file to validated contents of logs.

* ___aws.include_global_service_events (optional):___ Include evnets from global services such as IAM.

* ___aws.is_multi_region_trail (optional):___ Whether the trail is created in all regions or just the current region.

* ___aws.s3_force_destroy (optional):___ Bucket destroy will fail if the bucket is not empty.  Set to `"true"` if you REALLY want to destroy logs on teardown.


##### Optional settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/tf_threatstack_aws_integration?ref=<integration_version>"

  aws = {

    # ...

    cloudtrail_name         = string
    iam_role_name           = string
    sns_topic_name          = string
    sns_topic_display_name  = string
    sqs_queue_name          = string
    s3_bucket_name          = string
    s3_force_destroy        = string

    #...

  }
}
```

* ___aws.cloudtrail_name (optional):___ Name of CloudTrail trail.

* ___aws.iam_role_name (optional):___ Name of cross account IAM role grating access for Threat Stack to AWS environment.

* ___aws.sns_topic_name (optional):___ Name of SNS topic used by CloudTrail.

* ___aws.sns_topic_display_name (optional):___ SNS topic display name.

* ___aws.sqs_queue_name (optional):___ Name of SQS queue to forward events to.

* ___aws.s3_bucket_name (optional):___ Name of bucket to create to store logs.  Pay attention to the fact that domain name and account name will be prepended to thebucket to help prevent name collisions.

* ___aws.s3_bucket_prefix (optional):___ S3 prefix path for logs.  Useful is using a bucket used by other services. (Not recommended)

## Outputs
* ___cloudtrail_arn:___ ARN of CloudTrail.

* ___cloudtrail_home_region:___ Home region for CloudTrail

* ___cloudtrail_id:___ CloudTrail ID. Name of CloudTrail without full ARN string.

* ___cloudwatch_log_group_arn:___ ARN of CloudWatch log group for cloudTrail events.

* ___iam_role_arn:___ ARN of cross account IAM role granting Threat Stack access to environment.  **(Enter this value into Threat Stack when setting up.)**

* ___iam_role_name:___ Name of cross account IAM role granting Threat Stack access to environment.

* ___iam_role_cloudtrail_arn:___ ARN of IAM role allowing events to be logged to CloudWatch.

* ___iam_role_cloudtrail_name:___ Name of IAM role allowing events to be logged to CloudWatch.

* ___s3_bucket_arn:___ ARN of bucket for CloudTrail events.

* ___s3_bucket_id:___ Name of bucket for CloudTrail events.  **(Enter this value into Threat Stack when setting up.)**

* ___sns_topic_arn:___ ARN of SNS topic where CloudTrail events are forwarded to.

* ___sqs_queue_arn:___ ARN of SQS queue Threat Stack reads events from.

* ___sqs_queue_id:___ SQS queue ID / endpoint.

* ___sqs_queue_source:___ Name of SQS queue Threat Stack reads events from.  **(Enter this value into Threat Stack when setting up.)**
