// AWS Iam role for cross account access

data "template_file" "aws_iam_assume_role_policy" {
  template = file("${path.module}/aws_iam_assume_role_policy.tpl")
  vars = {
    threatstack_account_id  = var.threatstack.account_id
    threatstack_external_id = var.threatstack.external_id
  }
}

data "template_file" "aws_iam_role_policy" {
  template = file("${path.module}/aws_iam_role_policy.tpl")
  vars = {
    sqs_queue_arn = aws_sqs_queue.sqs.arn

    # This checks to see if a new bucket exists (null check)
    # If it is null, just give a null so coalesce skips it
    # If not null, return the arn of the bucket, which is what we really need
    s3_resource   = coalesce((aws_s3_bucket.bucket != null ? aws_s3_bucket.bucket[0].arn : null), var.existing_cloudtrail.s3_bucket_arn)
  }
}

resource "aws_iam_role" "role" {
  name               = var.aws_optional_conf.iam_role_name
  assume_role_policy = data.template_file.aws_iam_assume_role_policy.rendered
}

resource "aws_iam_role_policy" "role" {
  name = var.aws_optional_conf.iam_role_name
  role = aws_iam_role.role.id

  policy = data.template_file.aws_iam_role_policy.rendered
}

