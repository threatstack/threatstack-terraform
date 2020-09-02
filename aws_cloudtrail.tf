// AWS Cloudtrail
data "template_file" "aws_iam_cloudtrail_to_cloudwatch_assume_role_policy" {
  template = file(
    "${path.module}/aws_iam_cloudtrail_to_cloudwatch_assume_role_policy.tpl",
  )
}

data "template_file" "aws_iam_cloudtrail_to_cloudwatch_policy" {
  template = file("${path.module}/aws_iam_cloudtrail_to_cloudwatch_policy.tpl")
  vars = {
    aws_account_id      = var.aws_account_info.account_id
    aws_cloudtrail_name = var.aws_optional_conf.cloudtrail_name
    aws_region          = var.aws_account_info.region
  }
}

resource "aws_cloudwatch_log_group" "ct" {
  name = "/aws/cloudtrail/${var.aws_optional_conf.cloudtrail_name}"
  tags = {
    terraform = "true"
  }
  depends_on = [
    aws_iam_role_policy.ct,
    aws_s3_bucket_policy.bucket,
  ]
}

resource "aws_iam_role" "ct" {
  name               = "${var.aws_optional_conf.cloudtrail_name}-CloudTrailToCloudWatch"
  assume_role_policy = data.template_file.aws_iam_cloudtrail_to_cloudwatch_assume_role_policy.rendered
}

resource "aws_iam_role_policy" "ct" {
  name   = "CloudTrailToCloudWatch"
  role   = aws_iam_role.ct.id
  policy = data.template_file.aws_iam_cloudtrail_to_cloudwatch_policy.rendered
}

resource "aws_cloudtrail" "ct" {
  name                          = var.aws_optional_conf.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.bucket.id
  enable_logging                = var.aws_flags.enable_logging
  enable_log_file_validation    = var.aws_flags.enable_log_file_validation
  include_global_service_events = var.aws_flags.include_global_service_events
  is_multi_region_trail         = var.aws_flags.is_multi_region_trail
  cloud_watch_logs_group_arn    = "${replace(aws_cloudwatch_log_group.ct.arn, "/:\\*$/", "")}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.ct.arn
  sns_topic_name                = aws_sns_topic.sns.arn
  depends_on                    = [aws_s3_bucket_policy.bucket]
}

