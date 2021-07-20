# Set up default Control Plane Monitoring.
#
# Currently only AWS Cloudtrail is supported

# Variables

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

# Setting for integrating with an existing cloudtrail resource
#
variable "existing_cloudtrail" {
  description = "(Optional) Uses existing cloudtrail infrastructure instead of creating all new resources"
  type = object({
    cloudtrail_arn = string
    s3_bucket_arn  = string
  })

  default = null
}

# AWS-related configuration flags (Optional)
#
# The flags have defaults, so the module can work without these explicitly set
variable "s3_force_destroy" {
  description = "Whether or not to allow force destroying the bucket while it has contents."
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Whether to enable CloudTrail logging or not."
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Whether to enable CloudTrail log file validation or not."
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Whether or not to include global service events."
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether or not to create trail as multi-region."
  type        = bool
  default     = true
}

# AWS-related configuration settings (Optional)
#
# The settings have defaults, so the module can work without these explicitly set
variable "s3_bucket_name" { # buckets are global, thus the name is NOT optional as 'threatstack-integration' bucket already exists in S3.
  description = "The name for the S3 bucket to be created. Will be suffixed with 'threatstack-integration' unless s3_suffix is false."
  type        = string
}

variable "s3_suffix" {
  description = "Whether or not to include 'threatstack-integration' suffix on S3 bucket name."
  type        = bool
  default     = true
}

variable "cloudtrail_name" {
  description = "Name of the CloudTrail."
  type        = string
  default     = "ThreatStackIntegration"
}

variable "iam_role_name" {
  description = "Name of the cross account IAM role."
  type        = string
  default     = "ThreatStackIntegration"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic."
  type        = string
  default     = "ThreatStackIntegration"
}

variable "sns_topic_display_name" {
  description = "Display name of the SNS topic."
  type        = string
  default     = "Threat Stack integration topic."
}

variable "sqs_queue_name" {
  description = "Name of the SQS queue."
  type        = string
  default     = "ThreatStackIntegration"
}

variable "s3_bucket_prefix" {
  description = "The path prefix of the S3 bucket."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Any tags to apply to the resources created in this module."
  type        = map(string)
  default     = {}
}
