terragrunt = {
  # Configure Terragrunt to automatically store tfstate files in an S3 bucket
  remote_state {
    backend = "s3"
    config {
      encrypt = "true"
      bucket  = "example-com-example-prod-terraform"
      key     = "aws_cloudtrail.tfstate"
      region  = "us-east-1"
    }
  }
}

aws_account             = "example-prob"  # AWS credentials profile name
aws_profile             = "example-prob"
aws_region              = "us-east-1"

aws_cloudtrail_name = "example-prod"
s3_bucket_name = "cloudtrail"
is_multi_region_trail = true
