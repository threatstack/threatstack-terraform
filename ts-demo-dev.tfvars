terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an S3 bucket
  remote_state {
    backend = "s3"
    config {
      encrypt = "true"
      bucket  = "ts-demo-dev-terraform"
      key     = "aws_cloudtrail.tfstate"
      region  = "us-east-1"
    }
  }
}

aws_account             = "ts-demo-dev"  # AWS credentials profile name
aws_profile             = "ts-demo-dev"
aws_region              = "us-east-1"

aws_cloudtrail_name = "ts-demo-dev"
s3_bucket_name = "cloudtrail"
is_multi_region_trail = true
