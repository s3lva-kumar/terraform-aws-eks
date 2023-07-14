# terraform-aws-eks

This is the terraform module for setup the eks cluster.

## update the backend setting:
- The statefile will store in the S3 bucket for maintain the state of the cluster setup (_note: create a bucket by manually before you give it here_)
- Open the provider.tf file
- Give the bucket name in the "bucket" param under the backend setting which is you created before on the first setup.
- Give the region of the bucket in the "region" param under the backend setting.
- And also, give the aws "access" and "secret" keys and "region" on the provider block.
```hcl
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
  region     = ""
  access_key = ""
  secret_key = ""
}
```
## Update the module variable values:
### Module "vpc":
 - Open the main.tf file.
 - Give the vpc name.
 - Update the subnet details also.
 - Give the Cluster name

```hcl
module "vpc" {

  source              = "./modules/vpc"
  cluster-name        = ""
  vpc-name            = ""
  vpc-cidr            = "10.0.0.0/16"
  public-subnets-data = [{ name = "public-subnet1", ipsec = "10.0.1.0/24", az = "us-east-1a" }, { name = "public-subnet2", ipsec = "10.0.2.0/24", az = "us-east-1b" }, { name = "public-subnet3", ipsec = "10.0.3.0/24", az = "us-east-1c" }]
}
```

### Module "EKS":
- Open the main.tf file.
- Give the cluster name.(_note: give the same name what you gave on the VPC module_)
```hcl
module "eks" {
  extra_depends_on = [module.vpc]
  source           = "./modules/eks"
  cluster-name     = ""
  subnets-id       = module.vpc.public-subnet-id
}
```


### Once all the values given, then run the following command:
```bash
terraform init
terraform plan
terraform apply
```