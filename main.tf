// Setup Threat Stack integration

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

