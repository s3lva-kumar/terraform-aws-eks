output "public-subnet-id" {
  value = aws_subnet.public-subnet[*].id
}

output "vpc-id" {
  value = aws_vpc.vpc.id
}