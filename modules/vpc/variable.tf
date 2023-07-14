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