variable "vpc-name" {
  description = "vpc name"
}

variable "vpc-cidr" {
  description = "vpc cidr value"
}

variable "public-subnets-data" {
  type        = list(any)
  description = "List out the  Public Subnet names and cidr range"
}
variable "cluster-name" {}

#variable "private-subnets-data" {
#  type        = list(any)
#  description = "List out the  Private Subnet names and cidr range"
#}

#variable "db-subnets-data" {
#  type        = list(any)
#  description = "List out the  database Subnet names and cidr range"
#}