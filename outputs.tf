// Outputs
// If you want to reference these outputs outside of
// the module that uses this threatstack-terraform
// module, you need to define your own outputs in the
// module that uses this module.
//
// Example:
//
//    output "my_modules_output_for_cloudtrail_id" {
//      value = "${module.threatstack_aws_integration.cloudtrail_id}"
//    }

output "cloudtrail_id" {
  value = element(concat(aws_cloudtrail.ct.*.id, list("")), 0)
}

output "cloudtrail_home_region" {
  value = element(concat(aws_cloudtrail.ct.*.home_region, list("")), 0)
}

output "cloudtrail_arn" {
  value = element(concat(aws_cloudtrail.ct.*.arn, list("")), 0)
}

output "iam_role_cloudtrail_name" {
  value = element(concat(aws_iam_role.ct.*.name, list("")), 0)
}

output "iam_role_cloudtrail_arn" {
  value = element(concat(aws_iam_role.ct.*.arn, list("")), 0)
}

output "cloudwatch_log_group_arn" {
  value = element(concat(aws_cloudwatch_log_group.ct.*.arn, list("")), 0)
}

output "iam_role_name" {
  value = element(concat(aws_iam_role.role.*.name, list("")), 0)
}

output "iam_role_arn" {
  value = element(concat(aws_iam_role.role.*.arn, list("")), 0)
}

output "s3_bucket_id" {
  value = element(concat(aws_s3_bucket.bucket.*.id, list("")), 0)
}

output "s3_bucket_arn" {
  value = element(concat(aws_s3_bucket.bucket.*.arn, list("")), 0)
}

output "sns_topic_arn" {
  value = element(concat(aws_sns_topic.sns.*.arn, list("")), 0)
}

output "sqs_queue_id" {
  value = element(concat(aws_sqs_queue.sqs.*.id, list("")), 0)
}

output "sqs_queue_arn" {
  value = element(concat(aws_sqs_queue.sqs.*.arn, list("")), 0)
}

output "sqs_queue_source" {
  value = element(split(":", element(concat(aws_sqs_queue.sqs.*.arn, list("")), 0)), 5)
}

