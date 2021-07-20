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
> Example is based on the latest version. For example implementation of previous versions, see README in desired release.

> **This version of the module is compatible with Terraform 0.12+.**  Terraform 0.11 and earlier are not supported, and this module will not work. For a pre-0.12-compatible version of this module, see [v1.0.0 of this module](https://github.com/threatstack/threatstack-terraform/tree/v1.0.0).

To use, a user-created module should be defined that _imports_ this module (via the `source` parameter on the `module` setting.  Terraform will download and use the source module with the `terraform init` command, so there is no need to download it separately for use.  The minimum configuration for the user would look as follows (Be sure to adjust the git ref in the source value appropriately):

```hcl
module "threatstack_aws_integration" {
  source = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  s3_bucket_name   = "test"

  threatstack = {
    account_id  = var.threatstack_account_id
    external_id = var.threatstack_external_id
  }
}
```

## Threat Stack Setup

In Threat Stack click `Add Account` under _AWS Accounts_ fill in the relevant output values on the _Integrations_ page under _Settings_ and get the Threat Stack _Account ID_ and _External ID_.  Use these values for the `threatstack.account_id` and `threatstack.external_id` input variables (see below).  Run Terraform and get the outputs from it.

![Terraform output](https://github.com/threatstack/threatstack-terraform/raw/master/doc/terraform_output.png "Terraform output")

Record the Terraform output values, and use them to complete the configuration of the Threat Stack platform's side integration.  See sections 3 & 6 of the [AWS Manual Integration Setup](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup) page for details.


### Threat Stack configuration

All of the Threat Stack configuration is required.  Not explicitly defining these values when using this module will cause the integration to not work as expected.

The Threat Stack configuration is defined as follows:

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  #...

  # Strings generated from the Threat Stack Add Account page
  threatstack = {
    account_id  = string 
    external_id = string
  }

  #...

}
```

* ___threatstack.account_id:___ Threat Stack account ID associated with the Threat Stack org.  Used to find remote state information and is prepended to bucket names.

* ___threatstack.external_id:___ Account ID, used for CloudTrail integration.


### Using existing cloudtrail infrastructure

If you already have your Cloudtrail set up, with its corresponding cloudwatch log group and S3 bucket, you can configure this module to use this infrastructure by setting the following settings. The module will still set up the SQS and SNS resources required, as well as the various IAM resources to allow for the integration to talk to Threat Stack's platform.

> **NOTE:**
> Do not define the ___existing_cloudtrail___ variable at all if you want this module to manage all of the resources for the Threat Stack integration. By default, the ___existing_cloudtrail___ variable is set to `null`

```hcl
module "threatstack_aws_integration" {
  source      = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  # ...

  existing_cloudtrail = {
    cloudtrail_arn = string # The ARN of the existing cloudtrail with which you want to integrate.
    s3_bucket_arn  = string # The ARN of the existing S3 bucket.
  }

  # ...

}
```

* ___existing_cloudtrail.cloudtrail_arn (required if using existing cloudtrail):___ Only passed in so that it can be used as an output. Nothing in the integration directly refers to the existing cloudtrail itself.

* ___existing_cloudtrail.s3_bucket_arn (required if using existing cloudtrail):___ Used by the IAM role that links the Threat Stack account to the bucket with that contains the needed data.

## Outputs

### Exposing this module's outputs to the rest of your terraform definitions

As of Terraform 0.12, there is a [known change](https://github.com/hashicorp/terraform/issues/1940#issuecomment-513055570) in the structure of the terraform state file format that makes child module outputs inaccessible to tools like `terraform show`, `terraform output`, or via remote state data sources. A child module is any resource defined with the `module "<name>" { ... }` resource directive.

In order to refer to any of the outputs of this module outside of the implementing module, they must be wrapped as new outputs defined in the implementing module itself.

One way to do this (see below) is to define your infrastructure in your `main.tf`, and define your wrapper outputs in an `outputs.tf` file.

### Example implementation
> Example is based on the latest version. For example implementation of previous versions, see README in desired release.

This is the file that implements the threatstack-terraform module with your account-specific information:

`<your_module_directory>/main.tf:`
```hcl
module "threatstack_aws_integration" {
  source = "github.com/threatstack/threatstack-terraform?ref=<integration_version>"

  s3_bucket_name   = "test"

  threatstack = {
    account_id  = var.threatstack_account_id
    external_id = var.threatstack_external_id
  }
}
```

Using the name you gave to the instance of the threatstack-terraform module above, the output is defined as:

`<your_module_directory>/outputs.tf:`
```hcl
output "threatstack-aws-integration-cloudtrail-arn" {
  value = module.threatstack_aws_integration.cloudtrail_arn
}
```

You can wrap any of the threatstack-terraform module outputs listed below in the same way.

### Important outputs to expose to complete the integration

There are three output values that are needed to complete the integration by defining them in the Threat Stack Platform administrative settings (see the [official documentation](https://threatstack.zendesk.com/hc/en-us/articles/206512364-AWS-Manual-Integration-Setup) for more information), once the terraform module has been applid in the customer infrastructure. They are:

* ___iam_role_arn___
* ___s3_bucket_id___
* ___sqs_queue_source___

It is recommended that these outputs be rewrapped in outputs defined in your implementing module (as seen in the previous example), at a minimum. This will allow you to use the [`terraform output`](https://www.terraform.io/docs/commands/output.html) CLI command to get the value generated by this module.
