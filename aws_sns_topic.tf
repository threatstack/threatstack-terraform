// SNS topic

data "template_file" "aws_sns_topic_policy" {
  template = file("${path.module}/aws_sns_topic_policy.tpl")
}

resource "aws_sns_topic" "sns" {
  name         = var.aws_optional_conf.sns_topic_name
  display_name = var.aws_optional_conf.sns_topic_display_name
  depends_on   = [aws_iam_role.role]
}

resource "aws_sns_topic_policy" "sns" {
  arn    = aws_sns_topic.sns.arn
  policy = data.template_file.aws_sns_topic_policy.rendered
}

