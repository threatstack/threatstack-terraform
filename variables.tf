# Set up default Control Plane Monitoring.
#
# Currently only AWS Cloudtrail is supported

# Variables

# Threat Stack platform integration
variable "threatstack" {
  description = "Threat Stack-related Configuration"
  type = object({
    # Required parameters
    account_id  = string
    external_id = string
  })
}

variable "aws_account_info" {
  description = "AWS-related Configuration options"
  type = object({
    # Required parameters
    account_name = string
    account_id   = string
    region       = string
  })

  default = {
    account_name = null
    account_id   = null
    region       = null
  }
}

variable "aws_flags" {
  description = "AWS-related Configuration options"
  type = object({
    # Configuration flags
    s3_force_destroy              = bool
    enable_logging                = bool
    enable_log_file_validation    = bool
    include_global_service_events = bool
    is_multi_region_trail         = bool
  })

  default = {
    s3_force_destroy              = false
    enable_logging                = true
    enable_log_file_validation    = true
    include_global_service_events = true
    is_multi_region_trail         = true
  }
}

variable "aws_optional_conf" {
  type = object({
    cloudtrail_name        = string
    iam_role_name          = string
    sns_topic_name         = string
    sns_topic_display_name = string
    sqs_queue_name         = string
    s3_bucket_name         = string
    s3_bucket_prefix       = string
  })

  default = {
    cloudtrail_name        = "ThreatStackIntegration"
    iam_role_name          = "ThreatStackIntegration"
    sns_topic_name         = "ThreatStackIntegration"
    sns_topic_display_name = "Threat Stack integration topic."
    sqs_queue_name         = "ThreatStackIntegration"
    s3_bucket_name         = "threatstack-integration"
    s3_bucket_prefix       = "/"
  }
}
