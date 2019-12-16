# Set up default Control Plane Monitoring.
#
# Currently only AWS Cloudtrail is supported

# Variables

# 
variable "threatstack" = {
  type = object
  description = "Threat Stack-related Configuration"

# Required parameters

  account_id = string
  cloud_platform_id = string

}

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

# Optional parameters

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
