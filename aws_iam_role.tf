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
    s3_resource   = "${aws_s3_bucket.bucket.arn}/*"
  }
}

resource "aws_iam_role" "role" {
  name               = var.aws.optional_config. iam_role_name
  assume_role_policy = data.template_file.aws_iam_assume_role_policy.rendered
  depends_on         = [aws_iam_role_policy.ct]
}

resource "aws_iam_role_policy" "role" {
  name = var.aws.optional_config.iam_role_name
  role = aws_iam_role.role.id

  policy = data.template_file.aws_iam_role_policy.rendered
}

