terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

module "vpc" {

  source              = "./modules/vpc"
  cluster-name        = "eks-test-cluster"
  vpc-name            = "eks-test"
  vpc-cidr            = "10.0.0.0/16"
  public-subnets-data = [{ name = "public-subnet1", ipsec = "10.0.1.0/24", az = "us-east-1a" }, { name = "public-subnet2", ipsec = "10.0.2.0/24", az = "us-east-1b" }, { name = "public-subnet3", ipsec = "10.0.3.0/24", az = "us-east-1c" }]
}

module "eks" {
  extra_depends_on = [module.vpc]
  source           = "./modules/eks"
  cluster-name     = "eks-test-cluster"
  subnets-id       = module.vpc.public-subnet-id
}