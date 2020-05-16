// Setup SQS

data "template_file" "aws_sqs_queue_policy" {
  count    = var.enabled ? 1 : 0
  template = file("${path.module}/aws_sqs_queue_policy.tpl")
  vars = {
    sns_arn = aws_sns_topic.sns[0].arn
  }
}

resource "aws_sqs_queue" "sqs" {
  count      = var.enabled ? 1 : 0
  name       = var.aws_optional_conf.sqs_queue_name
  depends_on = [aws_sns_topic_policy.sns]
}

resource "aws_sqs_queue_policy" "sqs" {
  count     = var.enabled ? 1 : 0
  queue_url = aws_sqs_queue.sqs[0].id
  policy    = data.template_file.aws_sqs_queue_policy[0].rendered
}

resource "aws_sns_topic_subscription" "sqs" {
  count      = var.enabled ? 1 : 0
  topic_arn  = aws_sns_topic.sns[0].arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.sqs[0].arn
  depends_on = [aws_sqs_queue_policy.sqs]
}

