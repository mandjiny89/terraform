# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

# Create 4 S3 Buckets
resource "aws_s3_bucket" "mys3bucket" {

  # for_each Meta-Argument
  for_each = {
    dev  = "my-dapp-bucket-455"
    qa   = "my-qapp-bucket-455"
    stag = "my-sapp-bucket-455"
    prod = "my-papp-bucket-455"
  }

  bucket = "${each.key}-${each.value}"    # dev-my-dapp-bucket-455
  acl    = "private"

  tags = {
    Environment = each.key                      # dev
    bucketname  = "${each.key}-${each.value}"   # dev-my-dapp-bucket-455
    eachvalue   = each.value                    # my-dapp-bucket-455
  }
}
