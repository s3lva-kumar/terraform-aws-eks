output "vpc-id" {
  value = module.vpc.vpc-id
}

output "public-subnet" {
  value = module.vpc.public-subnet-id
}