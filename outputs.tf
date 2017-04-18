// Outputs
output "cloudtrail_id" {
  value = "${module.aws_cloudtrail.cloudtrail_id}"
}

output "cloudtrail_home_region" {
  value = "${module.aws_cloudtrail.cloudtrail_home_region}"
}

output "cloudtrail_arn" {
  value = "${module.aws_cloudtrail.cloudtrail_arn}"
}

output "iam_role_cloudtrail_arn" {
  value = "${module.aws_cloudtrail.iam_role_cloudtrail_arn}"
}

output "cloudwatch_log_group_arn" {
  value = "${module.aws_cloudtrail.cloudwatch_log_group_arn}"
}

output "iam_role_name" {
  value = "${aws_iam_role.role.name}"
}

output "iam_role_arn" {
  value = "${aws_iam_role.role.arn}"
}

output "s3_bucket_id" {
  value = "${module.aws_cloudtrail.s3_bucket_id}"
}

output "s3_bucket_arn" {
  value = "${module.aws_cloudtrail.s3_bucket_arn}"
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.sns.arn}"
}

output "sqs_queue_id" {
  value = "${aws_sqs_queue.sqs.id}"
}

output "sqs_queue_arn" {
  value = "${aws_sqs_queue.sqs.arn}"
}

output "sqs_queue_source" {
  value = "${element(split(":", aws_sqs_queue.sqs.arn), 5)}"
}

