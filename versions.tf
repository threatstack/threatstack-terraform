terraform {
  required_version = ">= 0.12.0, <= 0.13.6"

  required_providers {
    aws = {
      source  = "-/aws"
      version = ">= 3.0, < 3.45"
    }
  }
}
