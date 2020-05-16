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
  value = concat(aws_cloudtrail.ct.*.id, [""])[0]
}

output "cloudtrail_home_region" {
  value = concat(aws_cloudtrail.ct.*.home_region, [""])[0]
}

output "cloudtrail_arn" {
  value = concat(aws_cloudtrail.ct.*.arn, [""])[0]
}

output "iam_role_cloudtrail_name" {
  value = concat(aws_iam_role.ct.*.name, [""])[0]
}

output "iam_role_cloudtrail_arn" {
  value = concat(aws_iam_role.ct.*.arn, [""])[0]
}

output "cloudwatch_log_group_arn" {
  value = concat(aws_cloudwatch_log_group.ct.*.arn, [""])[0]
}

output "iam_role_name" {
  value = concat(aws_iam_role.role.*.name, [""])[0]
}

output "iam_role_arn" {
  value = concat(aws_iam_role.role.*.arn, [""])[0]
}

output "s3_bucket_id" {
  value = concat(aws_s3_bucket.bucket.*.id, [""])[0]
}

output "s3_bucket_arn" {
  value = concat(aws_s3_bucket.bucket.*.arn, [""])[0]
}

output "sns_topic_arn" {
  value = concat(aws_sns_topic.sns.*.arn, [""])[0]
}

output "sqs_queue_id" {
  value = concat(aws_sqs_queue.sqs.*.id, [""])[0]
}

output "sqs_queue_arn" {
  value = concat(aws_sqs_queue.sqs.*.arn, [""])[0]
}

output "sqs_queue_source" {
  value = element(split(":", aws_sqs_queue.sqs.*.arn), 5)
}

