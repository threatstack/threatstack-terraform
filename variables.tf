// Setup a default CloudTrail trail.

//Variables
variable "threatstack_account_id" {
  type = "string"
  description = "Threat Stack AWS account ID."
}

variable "threatstack_external_id" {
  type = "string"
  description = "Threat Stack AWS external ID."
}

variable "aws_account" {
  type = "string"
  description = "Used for naming S3 bucket in tf_example_aws_s3"
}

variable "aws_profile" {
  type = "string"
  description = "Used to configure AWS provider."
}

variable "aws_region" {
  type = "string"
  description = "Used for finding root state in tf_example_aws_s3"
}

variable "aws_cloudtrail_name" {
  type = "string"
  description = "Name of CloudTrail trail."
  default = "ThreatStackIntegration"
}

variable "aws_iam_role_name" {
  type = "string"
  description = "Threat Stack IAM role Name"
  default = "ThreatStackIntegration"
}

variable "aws_sns_topic_name" {
  type = "string"
  description = "Name of SNS topic."
  default = "ThreatStackIntegration"
}

variable "aws_sns_topic_display_name" {
  type = "string"
  description = "SNS topic display name"
  default = "Threat Stack integration topic."
}

variable "aws_sqs_queue_name" {
  type = "string"
  description = "Name of SNS topic."
  default = "ThreatStackIntegration"
}

variable "s3_bucket_name" {
  type = "string"
  description = "S3 Bucket for logs"
  default = "threatstack-integration"
}

variable "s3_bucket_prefix" {
  type = "string"
  description = "S3 prefix path for logs"
  default = "/"
}

variable "enable_logging" {
  description = "Enable logging, set to 'false' to pause logging."
  default = true
}

variable "enable_log_file_validation" {
  description = "Create signed digest file to validated contents of logs."
  default = true
}

variable "include_global_service_events" {
  description = "include evnets from global services such as IAM."
  default = true
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in all regions or just the current region."
  default = true
}

