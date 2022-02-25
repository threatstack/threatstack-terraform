// AWS Cloudtrail

locals {
  aws_iam_cloudtrail_to_cloudwatch_assume_role_policy = file("${path.module}/aws_iam_cloudtrail_to_cloudwatch_assume_role_policy.tpl")
  aws_iam_cloudtrail_to_cloudwatch_policy_vars = {
    aws_account_id      = var.aws_account_info.account_id
    aws_cloudtrail_name = var.aws_optional_conf.cloudtrail_name
    aws_region          = var.aws_account_info.region
  }
  aws_iam_cloudtrail_to_cloudwatch_policy = templatefile("${path.module}/aws_iam_cloudtrail_to_cloudwatch_policy.tpl", local.aws_iam_cloudtrail_to_cloudwatch_policy_vars)
}

resource "aws_cloudwatch_log_group" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = "/aws/cloudtrail/${var.aws_optional_conf.cloudtrail_name}"
  tags = var.aws_optional_conf.tags

  depends_on = [
    aws_iam_role_policy.ct,
    aws_s3_bucket_policy.bucket,
  ]
}

resource "aws_iam_role" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = "${var.aws_optional_conf.cloudtrail_name}-CloudTrailToCloudWatch"
  tags = var.aws_optional_conf.tags

  assume_role_policy = local.aws_iam_cloudtrail_to_cloudwatch_assume_role_policy
}

resource "aws_iam_role_policy" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name   = "CloudTrailToCloudWatch"
  role   = aws_iam_role.ct[0].id
  policy = local.aws_iam_cloudtrail_to_cloudwatch_policy
}

resource "aws_cloudtrail" "ct" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  name = var.aws_optional_conf.cloudtrail_name
  tags = var.aws_optional_conf.tags

  s3_bucket_name                = aws_s3_bucket.bucket[0].id
  enable_logging                = var.aws_flags.enable_logging
  enable_log_file_validation    = var.aws_flags.enable_log_file_validation
  include_global_service_events = var.aws_flags.include_global_service_events
  is_multi_region_trail         = var.aws_flags.is_multi_region_trail
  cloud_watch_logs_group_arn    = "${replace(aws_cloudwatch_log_group.ct[0].arn, "/:\\*$/", "")}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.ct[0].arn
  sns_topic_name                = aws_sns_topic.sns.arn
  depends_on                    = [aws_s3_bucket_policy.bucket]
}
