// AWS Cloudtrail
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current
}

data "aws_iam_policy_document" "ct_cw_role_policy" {
  statement {
    sid = "AWSCloudTrailCreatePutLogStream"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/cloudtrail/${var.cloudtrail_name}:log-stream:${local.account_id}_CloudTrail_${local.region}*"
    ]
  }
}

data "aws_iam_policy_document" "ct_cw_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = "/aws/cloudtrail/${var.cloudtrail_name}"
  tags = var.tags

  depends_on = [
    aws_iam_role_policy.ct,
    aws_s3_bucket_policy.bucket,
  ]
}

resource "aws_iam_role" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = "${var.cloudtrail_name}-CloudTrailToCloudWatch"
  tags = var.tags

  assume_role_policy = data.aws_iam_policy_document.ct_cw_assume_role_policy.json
}

resource "aws_iam_role_policy" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name   = "CloudTrailToCloudWatch"
  role   = aws_iam_role.ct[0].id
  policy = data.aws_iam_policy_document.ct_cw_role_policy.json
}

resource "aws_cloudtrail" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = var.cloudtrail_name
  tags = var.tags

  s3_bucket_name                = aws_s3_bucket.bucket[0].id
  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.ct[0].arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.ct[0].arn
  sns_topic_name                = aws_sns_topic.sns.arn
  depends_on                    = [aws_s3_bucket_policy.bucket]
}
