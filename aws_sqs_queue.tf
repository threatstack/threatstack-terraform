// Setup SQS

locals {
  aws_sqs_queue_policy_vars = {
    sns_arn = aws_sns_topic.sns.arn
  }
  aws_sqs_queue_policy = templatefile("${path.module}/aws_sqs_queue_policy.tpl", local.aws_sqs_queue_policy_vars)
}

resource "aws_sqs_queue" "sqs" {
  name = var.aws_optional_conf.sqs_queue_name
  tags = var.aws_optional_conf.tags

  depends_on = [aws_sns_topic_policy.sns]
}

resource "aws_sqs_queue_policy" "sqs" {
  queue_url = aws_sqs_queue.sqs.id
  policy    = local.aws_sqs_queue_policy
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn  = aws_sns_topic.sns.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.sqs.arn
  depends_on = [aws_sqs_queue_policy.sqs]
}
