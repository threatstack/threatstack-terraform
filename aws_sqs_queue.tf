// Setup SQS

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid       = "Allow-TS-SendMessage"
    actions   = ["sqs:SendMessage"]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.sns.arn]
    }
  }
}

resource "aws_sqs_queue" "sqs" {
  name = var.sqs_queue_name
  tags = var.tags

  depends_on = [aws_sns_topic_policy.sns]
}

resource "aws_sqs_queue_policy" "sqs" {
  queue_url = aws_sqs_queue.sqs.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn  = aws_sns_topic.sns.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.sqs.arn
  depends_on = [aws_sqs_queue_policy.sqs]
}
