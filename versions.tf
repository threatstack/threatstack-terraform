terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "-/aws"
      version = ">= 3.0, < 3.45"
    }
  }
}
