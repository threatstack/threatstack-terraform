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

resource "aws_iam_role" "role" {
  name = "${var.aws_iam_role_name}"
  assume_role_policy = "${data.template_file.aws_iam_assume_role_policy.rendered}"
}

resource "aws_iam_role_policy" "role" {
  name = "${var.aws_iam_role_name}"
  role = "${aws_iam_role.role.id}"

  policy = "${data.template_file.aws_iam_role_policy.rendered}"
}

