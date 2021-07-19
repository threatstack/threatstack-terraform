// AWS CloudTrail S3 Bucket
locals {
  s3_bucket_arn = aws_s3_bucket.bucket[0].arn
  bucket_name   = var.s3_suffix ? "${var.s3_bucket_name}-threatstack-integration" : var.s3_bucket_name
}

data "aws_iam_policy_document" "bucket_policy" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail
  statement {
    sid = "AWSCloudTrailAclCheck"
    principal {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = "s3:GetBucketAcl"
    resources = "${s3_bucket_arn}"
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principal {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = "s3:PutObject"
    resources = "${local.s3_bucket_arn}/AWSLogs/${local.account_id}/*"
    condition {
      test     = "StringEquals"
      values   = ["s3:x-amz-acl"]
      variable = "bucket-owner-full-control"
    }
  }
}


resource "aws_s3_bucket" "bucket" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  # This is to keep things consistent and prevent conflicts across
  # environments.
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = "false"
  }
  force_destroy = var.s3_force_destroy

  tags = var.tags

  depends_on = [aws_sns_topic_subscription.sqs]
}

resource "aws_s3_bucket_policy" "bucket" {
  count = var.existing_cloudtrail != null ? 0 : 1 # Don't create this if using an existing cloudtrail

  bucket = aws_s3_bucket.bucket[0].id
  policy = data.aws_iam_policy_document.bucket_policy[0].json
}

