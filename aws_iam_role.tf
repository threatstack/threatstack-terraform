// AWS Iam role for cross account access

data "template_file" "aws_iam_assume_role_policy" {
  count    = var.enabled ? 1 : 0
  template = file("${path.module}/aws_iam_assume_role_policy.tpl")
  vars = {
    threatstack_account_id  = var.threatstack.account_id
    threatstack_external_id = var.threatstack.external_id
  }
}

data "template_file" "aws_iam_role_policy" {
  count    = var.enabled ? 1 : 0
  template = file("${path.module}/aws_iam_role_policy.tpl")
  vars = {
    sqs_queue_arn = aws_sqs_queue.sqs[0].arn
    s3_resource   = "${aws_s3_bucket.bucket[0].arn}/*"
  }
}

resource "aws_iam_role" "role" {
  count              = var.enabled ? 1 : 0
  name               = var.aws_optional_conf.iam_role_name
  assume_role_policy = data.template_file.aws_iam_assume_role_policy[0].rendered
  depends_on         = [aws_iam_role_policy.ct]
}

resource "aws_iam_role_policy" "role" {
  count = var.enabled ? 1 : 0
  name  = var.aws_optional_conf.iam_role_name
  role  = aws_iam_role.role[0].id

  policy = data.template_file.aws_iam_role_policy[0].rendered
}

