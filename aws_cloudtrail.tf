// AWS Cloudtrail
data "template_file" "aws_iam_cloudtrail_to_cloudwatch_assume_role_policy" {
  template = file(
    "${path.module}/aws_iam_cloudtrail_to_cloudwatch_assume_role_policy.tpl",
  )
}

data "template_file" "aws_iam_cloudtrail_to_cloudwatch_policy" {
  template = file("${path.module}/aws_iam_cloudtrail_to_cloudwatch_policy.tpl")
  vars = {
    aws_account_id      = var.aws.account_id
    aws_cloudtrail_name = var.aws.optional_config.cloudtrail_name
    aws_region          = var.aws.region
  }
}

resource "aws_cloudwatch_log_group" "ct" {
  name = "/aws/cloudtrail/${var.aws.optional_config.cloudtrail_name}"
  tags = {
    terraform = "true"
  }
  depends_on = [
    aws_iam_role_policy.ct,
    aws_s3_bucket_policy.bucket,
  ]
}

resource "aws_iam_role" "ct" {
  name               = "${var.aws.optional_config.cloudtrail_name}-CloudTrailToCloudWatch"
  assume_role_policy = data.template_file.aws_iam_cloudtrail_to_cloudwatch_assume_role_policy.rendered
}

resource "aws_iam_role_policy" "ct" {
  name   = "CloudTrailToCloudWatch"
  role   = aws_iam_role.ct.id
  policy = data.template_file.aws_iam_cloudtrail_to_cloudwatch_policy.rendered
}

resource "aws_cloudtrail" "ct" {
  name                          = var.aws.optional_config.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.bucket.id
  enable_logging                = var.aws.enable_logging
  enable_log_file_validation    = var.aws.enable_log_file_validation
  include_global_service_events = var.aws.include_global_service_events
  is_multi_region_trail         = var.aws.is_multi_region_trail
  cloud_watch_logs_group_arn    = aws_cloudwatch_log_group.ct.arn
  cloud_watch_logs_role_arn     = aws_iam_role.ct.arn
  sns_topic_name                = aws_sns_topic.sns.arn
  depends_on                    = [aws_s3_bucket_policy.bucket]
}

