// SNS topic

data "template_file" "aws_sns_topic_policy" {
  count = var.enabled ? 1 : 0
  template = file("${path.module}/aws_sns_topic_policy.tpl")
}

resource "aws_sns_topic" "sns" {
  count = var.enabled ? 1 : 0
  name         = var.aws_optional_conf.sns_topic_name
  display_name = var.aws_optional_conf.sns_topic_display_name
  depends_on   = [aws_iam_role.role]
}

resource "aws_sns_topic_policy" "sns" {
  count = var.enabled ? 1 : 0
  arn    = aws_sns_topic.sns[0].arn
  policy = data.template_file.aws_sns_topic_policy[0].rendered
}

