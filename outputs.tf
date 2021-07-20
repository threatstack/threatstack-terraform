// Outputs
// If you want to reference these outputs outside of
// the module that uses this threatstack-terraform
// module, you need to define your own outputs in the
// module that uses this module.
//
// Example:
//
//    output "my_modules_output_for_cloudtrail_id" {
//      value = module.threatstack_aws_integration.cloudtrail_id
//    }

output "cloudtrail_id" {
  description = "Name or ID of the related CloudTrail if created in this module."
  value       = var.existing_cloudtrail == null ? aws_cloudtrail.ct[0].id : ""
}

output "cloudtrail_arn" {
  description = "ARN of the related CloudTrail."
  value       = var.existing_cloudtrail == null ? aws_cloudtrail.ct[0].arn : var.existing_cloudtrail.cloudtrail_arn
}

output "cloudtrail_home_region" {
  description = "Home region of the related CloudTrail."
  value       = var.existing_cloudtrail == null ? aws_cloudtrail.ct[0].home_region : ""
}

output "iam_role_cloudtrail_name" {
  description = "Name of the IAM role related to CloudTrail."
  value       = var.existing_cloudtrail == null ? aws_iam_role.ct[0].name : ""
}

output "iam_role_cloudtrail_arn" {
  description = "ARN of the IAM role related to CloudTrail."
  value       = var.existing_cloudtrail == null ? aws_iam_role.ct[0].arn : ""
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group created in this module."
  value       = var.existing_cloudtrail == null ? aws_cloudwatch_log_group.ct[0].arn : ""
}

output "s3_bucket_id" {
  description = "Name or ID of the related S3 bucket if created in this module."
  value       = var.existing_cloudtrail == null ? aws_s3_bucket.bucket[0].id : ""
}

output "s3_bucket_arn" {
  description = "ARN of the related S3 bucket."
  value       = var.existing_cloudtrail == null ? aws_s3_bucket.bucket[0].arn : var.existing_cloudtrail.s3_bucket_arn
}

output "iam_role_name" {
  description = "Name of the cross account role created in this module."
  value       = aws_iam_role.role.name
}

output "iam_role_arn" {
  description = "ARN of the cross account role created in this module."
  value       = aws_iam_role.role.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic created in this module."
  value       = aws_sns_topic.sns.arn
}

output "sqs_queue_id" {
  description = "ID of the SQS queue created in this module."
  value       = aws_sqs_queue.sqs.id
}

output "sqs_queue_arn" {
  description = "ARN of the SQS queue created in this module."
  value       = aws_sqs_queue.sqs.arn
}

output "sqs_queue_source" {
  description = "Name or source of the SQS queue created in this module."
  value       = aws_sqs_queue.sqs.name
}

