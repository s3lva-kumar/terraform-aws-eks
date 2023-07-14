# resource "aws_key_pair" "genkey" {
#   key_name   = "k8s"
#   public_key = trimspace(tls_private_key.ssh.public_key_openssh)
# }

# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits  = "4096"
# }


# node groups role and policy

resource "aws_iam_role" "node-policy" {
  name = "eks-node-group-policy"

  assume_role_policy = <<POLICY
{
"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "WorkerNodePolicy" {
  for_each = var.workernodepolicy
  role       = aws_iam_role.node-policy.name
  policy_arn = each.value.policy
}

#setup node group server

resource "aws_eks_node_group" "eks-node" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-worker-node"
  node_role_arn   = aws_iam_role.node-policy.arn
  subnet_ids      = var.subnets-id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  labels = {
    role = "nodes-general"
  }

  update_config {
    max_unavailable = 1
  }
  
  # remote_access {
  #   ec2_ssh_key = "k8s"
  # }

  depends_on = [
    aws_iam_role_policy_attachment.WorkerNodePolicy,
    var.extra_depends_on
  ]
}