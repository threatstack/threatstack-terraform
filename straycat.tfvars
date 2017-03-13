terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an S3 bucket
  remote_state {
    backend = "s3"
    config {
      encrypt = "true"
      bucket  = "straycat-dhs-org-straycat-terraform"
      key     = "aws_cloudtrail.tfstate"
      region  = "us-east-1"
    }
  }
}

aws_account             = "straycat"  # AWS credentials profile name
aws_profile             = "straycat"
aws_region              = "us-east-1"

aws_cloudtrail_name = "straycat"
s3_bucket_name = "cloudtrail"
