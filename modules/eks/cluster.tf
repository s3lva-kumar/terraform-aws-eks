resource "aws_eks_cluster" "cluster" {
  name     = var.cluster-name
  role_arn = aws_iam_role.cluster-role.arn

  vpc_config {
    subnet_ids = var.subnets-id
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    var.extra_depends_on
  ]
}

resource "aws_iam_role" "cluster-role" {
  name = "${var.cluster-name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster-role.name
}

#resource "aws_eks_cluster" "cluster-log" {
 # depends_on = [aws_cloudwatch_log_group.log-group]

#  enabled_cluster_log_types = ["api", "audit"]
#  name                      = var.cluster-name
#}

#resource "aws_cloudwatch_log_group" "log-group" {
#  name              = "/aws/eks/${var.cluster-name}/cluster"
#  retention_in_days = 14

#}