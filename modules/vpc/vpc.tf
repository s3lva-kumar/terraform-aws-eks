# VPC creation

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = var.vpc-name
  }
}

# InternetGateway creation and Attachment

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.vpc-name}-IGW"
  }
}

# Subnet group creation

resource "aws_subnet" "public-subnet" {
  count      = length(var.public-subnets-data)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public-subnets-data[count.index].ipsec
  availability_zone = var.public-subnets-data[count.index].az
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = var.public-subnets-data[count.index].name,
    "kubernetes.io/role/elb" = "1",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}