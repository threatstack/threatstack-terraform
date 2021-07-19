// SNS topic
data "aws_iam_policy_document" "topic_policy" {
  statement {
    sid       = "AWSCloudTrailSNSPolicy"
    actions   = ["SNS:Publish"]
    resources = "*"
    principal {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_sns_topic" "sns" {
  name = var.sns_topic_name
  tags = var.tags

  display_name = var.sns_topic_display_name
  depends_on   = [aws_iam_role.role]
}

resource "aws_sns_topic_policy" "sns" {
  arn    = aws_sns_topic.sns.arn
  policy = data.aws_iam_policy_document.topic_policy.json
}

