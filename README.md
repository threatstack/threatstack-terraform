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

## Dependencies

This Terraform module currently depends on the following providers as dependencies:

* `template` ~> 2.1
* `aws` ~> 2.0

## Usage
> **This version of the module is compatible with Terraform 0.12+.**  Terraform 0.11 and earlier are not supported, and this module will not work. For a pre-0.12-compatible version of this module, see [v1.0.0 of this module](https://github.com/threatstack/threatstack-terraform/tree/v1.0.0).

To use, a user-created module should be defined that _imports_ this module (via the `source` parameter on the `module` setting.  Terraform will download and use the source module with the `terraform init` command, so there is no need to download it separately for use.  The minimum configuration for the user would look as follows (Be sure to adjust the git ref in the source value appropriately):

```hcl
module "threatstack_aws_integration" { # THe name of the module here is arbitrary and can be whatever makes it easily identifiable to the end-user
  source                        = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  threatstack = {
    account_id        = "<THREATSTACK_AWS_ACCOUNT_ID>"
    external_id       = "<THREATSTACK_AWS_EXTERNAL_ID>"
  }

  aws_account_info = {
    account_id        = "<AWS_ACCOUNT_ID>"
    region            = "us-east-1"
  }
}
```

## Threat Stack Setup

In Threat Stack click `Add Account` under _AWS Accounts_ fill in the relevant output values on the _Integrations_ page under _Settings_ and get the Threat Stack _Account ID_ and _External ID_.  Use these values for the `threatstack.account_id` and `threatstack.external_id` input variables (see below).  Run Terraform and get the outputs from it.

![Terraform output](https://github.com/threatstack/threatstack-terraform/raw/master/doc/terraform_output.png "Terraform output")

Record the Terraform output values, and use them to complete the configuration of the Threat Stack platform's side integration.  See sections 3 & 6 of the [AWS Manual Integration Setup](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup) page for details.

## Variables

The module's input variables are defined in their own Terraform variable objects.  They are as follows:

* ___threatstack:___ **(REQUIRED)** Threat Stack-specific settings to deploy the integration.  The defaults are null, so the integration will fail if not set.

* ___aws_account_info:___ **(REQUIRED)** AWS account specifics to deploy the integration.  The defaults are null, so the integration will fail if not set.

* ___aws_flags:___ **(Optional)** The flags have defaults, so the module can work without these explicitly set.

* ___aws_optional_conf:___ **(Optional)** The settings have defaults, so the module can work without these explicitly set.

* ___enabled:___ **(Optional)**  Enable this module. Defaults to `true` so module will be created by default.


#### Threat Stack configuration

All of the Threat Stack configuration is required.  Not explicitly defining these values when using this module will cause the integration to not work as expected.

The Threat Stack configuration is defined as follows:

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

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

This Terraform input variable is split into 3 sections: required settings, flag settings, and optional settings

##### Required settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  aws_account_info = {

    # ...

    account_id   = string
    region       = string

    #...

  }
}
```

* ___aws_account_info.account_id:___ Account ID, used for CloudTrail integration.

* ___aws_account_info.region:___ AWS region.  Used to find remote state.

##### Flag settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  aws_flags = {

    # ...

    enable_logging                = bool # Defaults to `true`
    enable_log_file_validation    = bool # Defaults to `true`
    include_global_service_events = bool # Defaults to `true`
    is_multi_region_trail         = bool # Defaults to `true`
    s3_force_destroy              = bool # Defaults to `false`
    
    #...

  }
}

```
* ___aws_flags.enable_logging (optional):___ Enable logging, set to 'false' to pause logging.

* ___aws_flags.enable_log_file_validation (optional):___ Create signed digest file to validated contents of logs.

* ___aws_flags.include_global_service_events (optional):___ Include evnets from global services such as IAM.

* ___aws_flags.is_multi_region_trail (optional):___ Whether the trail is created in all regions or just the current region.

* ___aws_flags.s3_force_destroy (optional):___ Bucket destroy will fail if the bucket is not empty.  Set to `"true"` if you REALLY want to destroy logs on teardown.


##### Optional settings

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  aws_optional_conf = {

    # ...

    cloudtrail_name         = string # Defaults to "ThreatStackIntegration"
    iam_role_name           = string # Defaults to "ThreatStackIntegration"
    sns_topic_name          = string # Defaults to "ThreatStackIntegration"
    sns_topic_display_name  = string # Defaults to "Threat Stack integration topic."
    sqs_queue_name          = string # Defaults to "ThreatStackIntegration"
    s3_bucket_name          = string # Defaults to "threatstack-integration"
    s3_force_destroy        = string # Defaults to "/"

    #...

  }
}
```

* ___aws_optional_conf.cloudtrail_name (optional):___ Name of CloudTrail trail.

* ___aws_optional_conf.iam_role_name (optional):___ Name of cross account IAM role gating access for Threat Stack to AWS environment.

* ___aws_optional_conf.sns_topic_name (optional):___ Name of SNS topic used by CloudTrail.

* ___aws_optional_conf.sns_topic_display_name (optional):___ SNS topic display name.

* ___aws_optional_conf.sqs_queue_name (optional):___ Name of SQS queue to forward events to.

* ___aws_optional_conf.s3_bucket_name (optional):___ Name of bucket to create to store logs.  Pay attention to the fact that account name will be prepended to the provided bucket name to help prevent name collisions.

* ___aws_optional_conf.s3_bucket_prefix (optional):___ S3 prefix path for logs.  Useful is using a bucket used by other services. (Not recommended)


## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify argument `enabled`.
This is useful in case of using `threatstack` module inside another module.

```hcl
# This VPC will not be created
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  enabled = false
  # ... omitted
}
```

## Outputs

### Exposing this module's outputs to the rest of your terraform definitions

As of Terraform 0.12, there is a [known change](https://github.com/hashicorp/terraform/issues/1940#issuecomment-513055570) in the structure of the terraform state file format that makes child module outputs inaccessible to tools like `terraform show`, `terraform output`, or via remote state data sources. A child module is any resource defined with the `module "<name>" { ... }` resource directive.

In order to refer to any of the outputs of this module outside of the implementing module, they must be wrapped as new outputs defined in the implementing module itself.

One way to do this (see below) is to define your infrastructure in your `main.tf`, and define your wrapper outputs in an `outputs.tf` file.

#### Example implementation

This is the file that implements the threatstack-terraform module with your account-specific information:

`<your_module_directory>/main.tf:`
```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  aws_account_info = {
    # ...
  }

  aws_flags = {
    # ...
  }

  aws_optional_conf = {
    # ...
  }
}
```

Using the name you gave to the instance of the threatstack-terraform module above, the output is defined as:

`<your_module_directory>/outputs.tf:`
```hcl
output "threatstack-aws-integration-cloudtrail-arn" {
  value = "${module.threatstack_aws_integration.cloudtrail_arn}"
}
```

You can wrap any of the threatstack-terraform module outputs listed below in the same way.

#### Important outputs to expose to complete the integration

There are three output values that are needed to complete the integration by defining them in the Threat Stack Platform administrative settings (see the [official documentation](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup) for more information), once the terraform module has been applid in the customer infrastructure. They are:

* ___iam_role_arn___
* ___s3_bucket_id___
* ___sqs_queue_source___

It is recommended that these outputs be rewrapped in outputs defined in your implementing module (as seen in the previous example), at a minimum. This will allow you to use the [`terraform output`](https://www.terraform.io/docs/commands/output.html) CLI command to get the value generated by this module.

### List of all outputs from this module

> **NOTE:**
> You can also see this list in this module's `outputs.tf` file.

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
