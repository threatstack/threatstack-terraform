# tf_threatstack_aws_integration
Setup Threat Stack <-> AWS integration module

This module provides the ability to setup Threat Stack integration via Terraform.  This module will setup the following:


## Usage
To use this module you need to create a Terraform configuration that utilizes this module.  A basic example configuration would look as follows (Be sure to adjust the git ref in the source value appropriately):

```hcl
module "threatstack_aws_integration" {
  source                        = "github.com/threatstack/tf_threatstack_aws_integration?ref=v1.0.0"
  aws_account                   = "AWS_ACCOUNT_NAME"
  aws_account_id                = "AWS_ACCOUNT_ID"
  aws_region                    = "us-east-1"
  threatstack_account_id        = "THREATSTACK_AWS_ACCOUNT_ID"
  threatstack_external_id       = "THREATSTACK_AWS_EXTERNAL_ID"
}
```

## Variables
* ___aws_account:___ Name of AWS account.  Used to find remote state information and is prepended to bucket names.

* ___aws_account_id:___ Account ID, used for CloudTrail integration.

* ___aws_region:___ AWS region.  Used to find remote state.

* ___aws_cloudtrail_name (optional):___ Name of CloudTrail trail.

* ___aws_iam_role_name (optional):___ Name of cross account IAM role grating access for Threat Stack to AWS environment.

* ___aws_sns_topic_name (optional):___ Name of SNS topic used by CloudTrail.

* ___aws_sns_topic_display_name (optional):___ SNS topic display name.

* ___aws_sqs_queue_name (optional):___ Name of SQS queue to forward events to.

* ___s3_bucket_name (optional):___ Name of bucket to create to store logs.  Pay attention to the fact that domain name and account name will be prepended to thebucket to help prevent name collisions.

* ___s3_bucket_prefix (optional):___ S3 prefix path for logs.  Useful is using a bucket used by other services. (Not recommended)

* ___s3_force_destroy (optional):___ Bucket destroy will fail if the bucket is not empty.  Set to `"true"` if you REALLY want to destroy logs on teardown.

* ___enable_logging (optional):___ Enable logging, set to 'false' to pause logging.

* ___enable_log_file_validation (optional):___ Create signed digest file to validated contents of logs.

* ___include_global_service_events (optional):___ Include evnets from global services such as IAM.

* ___is_multi_region_trail (optional):___ Whether the trail is created in all regions or just the current region.


## Outputs
* cloudtrail_arn: ARN of CloudTrail.

* cloudtrail_home_region: Home region for CloudTrail

* cloudtrail_id: CloudTrail ID. Name of CloudTrail without full ARN string.

* cloudwatch_log_group_arn: ARN of CloudWatch log group for cloudTrail events.

* iam_role_arn: ARN of cross account IAM role granting Threat Stack access to environment.  (Enter this value into Threat Stack when setting up.)

* iam_role_name: Name of cross account IAM role granting Threat Stack access to environment.

* iam_role_cloudtrail_arn: ARN of IAM role allowing events to be logged to CloudWatch.

* iam_role_cloudtrail_name: Name of IAM role allowing events to be logged to CloudWatch.

* s3_bucket_arn: ARN of bucket for CloudTrail events.

* s3_bucket_id: Name of bucket for CloudTrail events.  (Enter this value into Threat Stack when setting up.)

* sns_topic_arn: ARN of SNS topic where CloudTrail events are forwarded to.

* sqs_queue_arn: ARN of SQS queue Threat Stack reads events from.

* sqs_queue_id: SQS queue ID / endpoint.

* sqs_queue_source: Name of SQS queue Threat Stack reads events from.  (Enter this value into Threat Stack when setting up.)
