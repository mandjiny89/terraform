# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "test-terra-2806"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1" 
    # For State Locking, LockID
    dynamodb_table = "test-locking"    
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}