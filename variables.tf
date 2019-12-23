# Set up default Control Plane Monitoring.
#
# Currently only AWS Cloudtrail is supported

# Variables

# Threat Stack platform integration
variable "threatstack" {
  description = "Threat Stack-related Configuration"
  type = object({
    # Required parameters
    account_id = string
    external_id = string
  })
}

variable "aws" {
  description = "AWS-related Configuration options"
  type = object({
    # Required parameters
    account_name = string
    account_id   = string
    region       = string

    # Configuration flags
    s3_force_destroy              = string
    enable_logging                = string
    enable_log_file_validation    = string
    include_global_service_events = string
    is_multi_region_trail         = string

    # Optional parameters
    optional_config = object({
      type = object

      cloudtrail_name         = string
      iam_role_name           = string
      sns_topic_name          = string
      sns_topic_display_name  = string
      sqs_queue_name          = string
      s3_bucket_name          = string
      s3_bucket_prefix        = string
    })
  })

  # Default values

  default      = {
    account_name = null
    account_id   = null
    region       = null

    enable_logging                = true
    enable_log_file_validation    = true
    include_global_service_events = true
    is_multi_region_trail         = true
    s3_force_destroy              = false

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
