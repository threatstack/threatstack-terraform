// AWS CloudTrail S3 Bucket
data "template_file" "aws_s3_bucket_policy" {
  template = file("${path.module}/aws_s3_bucket_policy.tpl")

  vars = {
    aws_account_id = var.aws_account_info.account_id
    s3_bucket_arn  = aws_s3_bucket.bucket.arn
  }
}

resource "aws_s3_bucket" "bucket" {
  # This is to keep things consistent and prevent conflicts across
  # environments.
  bucket = "${var.aws_account_info.account_name}-${var.aws_optional_conf.s3_bucket_name}"
  acl    = "private"

  versioning {
    enabled = "false"
  }
  force_destroy = var.aws_flags.s3_force_destroy
  tags = {
    terraform = "true"
  }
  depends_on = [aws_sns_topic_subscription.sqs]
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.template_file.aws_s3_bucket_policy.rendered
}

