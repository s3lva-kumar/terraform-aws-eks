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
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.WorkerNodePolicy,
  ]
}