# Set up default Control Plane Monitoring.
#
# Currently only AWS Cloudtrail is supported

# Variables

# Enable this module (Optional)
#
# Sometimes you need to have a way to create resources conditionally
# Terraform does not allow to use count inside module block
# To get around this, specify the argument `enabled` defaults to `true`
variable "enabled" {
  description = "(Optional) Controls if resources should be created (it affects all resources)"
  type = bool
  default = true
}

# Threat Stack platform integration (REQUIRED)
#
# Threat Stack-specific settings to deploy the integration
# The defaults are null, so the integration will fail if not set
variable "threatstack" {
  description = "(REQUIRED) Threat Stack-related Configuration"
  type = object({
    # Required parameters
    account_id  = string
    external_id = string
  })
}


# AWS account information (REQUIRED)
#
# AWS account specifics to deploy the integration.
# The defaults are null, so the integration will fail if not set
variable "aws_account_info" {
  description = "(REQUIRED) AWS account settings"
  type = object({
    account_id   = string
    region       = string
  })

  default = {
    account_id   = null
    region       = null
  }
}

# AWS-related configuration flags (Optional)
#
# The flags have defaults, so the module can work without these explicitly set
variable "aws_flags" {
  description = "(Optional) AWS-related Configuration flags"
  type = object({
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

# AWS-related configuration settings (Optional)
#
# The settings have defaults, so the module can work without these explicitly set
variable "aws_optional_conf" {
  description = "(Optional) AWS-related Configuration settings"
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
