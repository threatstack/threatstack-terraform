// Setup a default CloudTrail trail.

//Variables
variable "threatstack" = {
  type = object
  description = "Threat Stack-related Configuration"

  account_id = string
  cloud_platform_id = string

}

# variable "threatstack_account_id" {
#   type        = string
#   description = "Threat Stack AWS account ID."
# }

# variable "threatstack_external_id" {
#   type        = string
#   description = "Threat Stack AWS external ID."
# }

variable "aws" {
  type = object
  description = "AWS-related Configuration options"

# Required parameters

  account_name = string
  account_id   = string
  region       = string

# Configuration flags

  s3_force_destroy              = boolean
  enable_logging                = boolean
  enable_log_file_validation    = boolean
  include_global_service_events = boolean
  is_multi_region_trail         = boolean

# Optional configuration options

  optional_config = {
    type = object

    cloudtrail_name         = string
    iam_role_name           = string
    sns_topic_name          = string
    sns_topic_display_name  = string
    sqs_queue_name          = string
    s3_bucket_name          = string
    s3_bucket_prefix        = string
  }

# Default values

  default      = {
    account_name = null
    account_id   = null
    region       = null

    s3_force_destroy              = false
    enable_logging                = true
    enable_log_file_validation    = true
    include_global_service_events = true
    is_multi_region_trail         = true

    optional_config = {
      cloudtrail_name         = "ThreatStackIntegration"
      iam_role_name           = "ThreatStackIntegration"
      sns_topic_name          = "ThreatStackIntegration"
      sns_topic_display_name  = "Threat Stack integration topic."
      sqs_queue_name          = "ThreatStackIntegration"
      s3_bucket_name          = "threatstack-integration"
      s3_bucket_prefix        = "/"
    }
  }

}

# variable "aws_account" {
#   type        = string
#   description = "Used for naming S3 bucket in tf_example_aws_s3"
# }

# variable "aws_account_id" {
#   type        = string
#   description = "AWS account ID"
# }

# variable "aws_region" {
#   type        = string
#   description = "Used for finding root state in tf_example_aws_s3"
# }

# variable "aws_cloudtrail_name" {
#   type        = string
#   description = "Name of CloudTrail trail."
#   default     = "ThreatStackIntegration"
# }

# variable "aws_iam_role_name" {
#   type        = string
#   description = "Threat Stack IAM role Name"
#   default     = "ThreatStackIntegration"
# }

# variable "aws_sns_topic_name" {
#   type        = string
#   description = "Name of SNS topic."
#   default     = "ThreatStackIntegration"
# }

# variable "aws_sns_topic_display_name" {
#   type        = string
#   description = "SNS topic display name"
#   default     = "Threat Stack integration topic."
# }

# variable "aws_sqs_queue_name" {
#   type        = string
#   description = "Name of SNS topic."
#   default     = "ThreatStackIntegration"
# }

# variable "s3_bucket_name" {
#   type        = string
#   description = "S3 Bucket for logs"
#   default     = "threatstack-integration"
# }

# variable "s3_bucket_prefix" {
#   type        = string
#   description = "S3 prefix path for logs"
#   default     = "/"
# }

# variable "s3_force_destroy" {
#   type        = string
#   description = "Destroy S3 bucket even if not empty."
#   default     = "false"
# }

# variable "enable_logging" {
#   description = "Enable logging, set to 'false' to pause logging."
#   default     = true
# }

# variable "enable_log_file_validation" {
#   description = "Create signed digest file to validated contents of logs."
#   default     = true
# }

# variable "include_global_service_events" {
#   description = "include evnets from global services such as IAM."
#   default     = true
# }

# variable "is_multi_region_trail" {
#   description = "Whether the trail is created in all regions or just the current region."
#   default     = true
# }

