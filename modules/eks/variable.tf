variable "cluster-name" {
  description = "EKS cluster name"
}

variable "subnets-id" {
  type = list(any)
  description = "vpc subnet ids for cluster"
}

variable "workernodepolicy" {
  default = {
    "policy1" = {
      "policy"     = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    },
    "policy2" = {
       "policy" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    },
    "policy3" = {
      "policy" = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    }  
  }
}

variable "extra_depends_on" {}

#variable "ami" {}
#variable "instance_type" {}