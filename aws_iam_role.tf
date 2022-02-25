// AWS Iam role for cross account access

locals {
  aws_iam_assume_role_policy_vars = {
    threatstack_account_id  = var.threatstack.account_id
    threatstack_external_id = var.threatstack.external_id
  }
  aws_iam_assume_role_policy = templatefile("${path.module}/aws_iam_assume_role_policy.tpl", local.aws_iam_assume_role_policy_vars)

  aws_iam_role_policy_vars = {
    sqs_queue_arn = aws_sqs_queue.sqs.arn

    # This checks to see if a new bucket exists (null check)
    # If it is null, just give a null so coalesce skips it
    # If not null, return the arn of the bucket, which is what we really need
    s3_resource = coalesce((length(aws_s3_bucket.bucket) > 0 ? aws_s3_bucket.bucket[0].arn : ""), (var.existing_cloudtrail != null ? var.existing_cloudtrail.s3_bucket_arn : ""))
  }
  aws_iam_role_policy = templatefile("${path.module}/aws_iam_role_policy.tpl", local.aws_iam_role_policy_vars)
}
resource "aws_iam_role" "role" {
  name = var.aws_optional_conf.iam_role_name
  tags = var.aws_optional_conf.tags

  assume_role_policy = local.aws_iam_assume_role_policy
}

resource "aws_iam_role_policy" "role" {
  name = var.aws_optional_conf.iam_role_name
  role = aws_iam_role.role.id

  policy = local.aws_iam_role_policy
}

