// Setup Threat Stack integration

// Backend
# NOTE: Backends cannot contain interpolations at this time. :-|
terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "ts-demo-dev-terraform"
    key     = "aws_cloudtrail_threatstack.tfstate"
    region  = "us-east-1"
  }
}


// AWS provider
provider "aws" {
  profile = "${var.aws_profile}"
  region  = "${var.aws_region}"
}


// Data
data "terraform_remote_state" "root" {
  backend = "s3"
  config = {
    bucket  = "${var.aws_account}-terraform"
    key     = "root.tfstate"
    region  = "${var.aws_region}"
  }
}

data "template_file" "aws_sns_topic_policy" {
  template = "${file("${path.module}/aws_sns_topic_policy.tpl")}"
}

data "template_file" "aws_sqs_queue_policy" {
  template = "${file("${path.module}/aws_sqs_queue_policy.tpl")}"
  vars {
    sns_arn = "${aws_sns_topic.sns.arn}"
  }
}

data "template_file" "aws_iam_assume_role_policy" {
  template = "${file("${path.module}/aws_iam_assume_role_policy.tpl")}"
  vars {
    threatstack_account_id = "${var.threatstack_account_id}"
    threatstack_external_id = "${var.threatstack_external_id}"
  }
}

data "template_file" "aws_iam_role_policy" {
  template = "${file("${path.module}/aws_iam_role_policy.tpl")}"
  vars {
    sqs_queue_arn = "${aws_sqs_queue.sqs.arn}"
    s3_resource = "${aws_sqs_queue.sqs.arn}/*"
  }
}


// Resources
module "aws_cloudtrail" {
  source                        = "../tf_threatstack_aws_cloudtrail"
  aws_cloudtrail_name           = "${var.aws_cloudtrail_name}"
  s3_bucket_name                = "${var.s3_bucket_name}"
  enable_logging                = "${var.enable_logging}"
  enable_log_file_validation    = "${var.enable_log_file_validation}"
  include_global_service_events = "${var.include_global_service_events}"
  is_multi_region_trail         = "${var.enable_log_file_validation}"
  aws_account                   = "${var.aws_account}"
  aws_account_id                = "${data.terraform_remote_state.root.aws_account_id}"
  aws_region                    = "${var.aws_region}"
}

resource "aws_sns_topic" "sns" {
  name = "${var.aws_sns_topic_name}"
  display_name = "${var.aws_sns_topic_display_name}"
}

resource "aws_sns_topic_policy" "sns" {
  arn = "${aws_sns_topic.sns.arn}"
  policy = "${data.template_file.aws_sns_topic_policy.rendered}"
}

resource "aws_sqs_queue" "sqs" {
  name = "${var.aws_sqs_queue_name}"
}

resource "aws_sqs_queue_policy" "sqs" {
  queue_url = "${aws_sqs_queue.sqs.id}"
  policy = "${data.template_file.aws_sqs_queue_policy.rendered}"
}

resource "aws_sns_topic_subscription" "sqs" {
  topic_arn = "${aws_sns_topic.sns.arn}"
  protocol = "sqs"
  endpoint = "${aws_sqs_queue.sqs.arn}"
}

resource "aws_iam_role" "role" {
  name = "${var.aws_iam_role_name}"
  assume_role_policy = "${data.template_file.aws_iam_assume_role_policy.rendered}"
}

resource "aws_iam_role_policy" "role" {
  name = "${var.aws_iam_role_name}"
  role = "${aws_iam_role.role.id}"

  policy = "${data.template_file.aws_iam_role_policy.rendered}"
}

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

