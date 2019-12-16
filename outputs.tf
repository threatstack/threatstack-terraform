// Outputs
output "cloudtrail_id" {
  value = aws_cloudtrail.ct.id
}

output "cloudtrail_home_region" {
  value = aws_cloudtrail.ct.home_region
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.ct.arn
}

output "iam_role_cloudtrail_name" {
  value = aws_iam_role.ct.name
}

output "iam_role_cloudtrail_arn" {
  value = aws_iam_role.ct.arn
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.ct.arn
}

output "iam_role_name" {
  value = aws_iam_role.role.name
}

output "iam_role_arn" {
  value = aws_iam_role.role.arn
}

output "s3_bucket_id" {
  value = aws_s3_bucket.bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "sns_topic_arn" {
  value = aws_sns_topic.sns.arn
}

output "sqs_queue_id" {
  value = aws_sqs_queue.sqs.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.sqs.arn
}

output "sqs_queue_source" {
  value = element(split(":", aws_sqs_queue.sqs.arn), 5)
}

