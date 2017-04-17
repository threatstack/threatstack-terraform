# terraform-example-aws-cloudtrail-threatstack
Setup Threat Stack <-> AWS integration

## Variables
### Required
* ___aws_cloudtrail_name:___ Name of CloudTrail trail.

* ___s3_bucket_name:___ Name of bucket to create to store logs.  Pay attention to the fact that domain name and account name will be prepended to thebucket to help prevent name collisions.

* ___aws_account:___ Name of AWS account.  Used to find remote state information and is prepended to bucket names.

* ___aws_account_id:___ Account ID, used for CloudTrail integration.

* ___aws_region:___ AWS region.  Used to find remote state.

### Optional
* ___enable_logging:___ Enable logging, set to 'false' to Pause logging.

* ___enable_log_file_validation:___ Create signed digest file to validated contents of logs.

* ___include_global_service_events:___ Include evnets from global services such as IAM.

* ___is_multi_region_trail:___ Whether the trail is created in all regions or just the current region.

