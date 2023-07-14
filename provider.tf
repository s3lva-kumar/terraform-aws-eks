terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "" # give the bucket name
    key = "eks-setup/terraform.tfstate" 
    region = ""  # give the bucket region 
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}