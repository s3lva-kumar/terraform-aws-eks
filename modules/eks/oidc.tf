resource "aws_iam_policy" "alb-policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/templates/iam_policy.json")
}

data "aws_caller_identity" "current" {}

data "tls_certificate" "eks-cret" {
  url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "k8s-cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.eks-cret.certificates[*].sha1_fingerprint
  url             = data.tls_certificate.eks-cret.url
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-alb-ingress-controller"]

    }
    condition {
      test     = "StringEquals"
      variable = "${replace(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]

    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidc-role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "AmazonEKSLoadBalancerControllerRole"
  depends_on = [aws_eks_cluster.cluster]
}

resource "aws_iam_role_policy_attachment" "attach-alb-role" {
  policy_arn = aws_iam_policy.alb-policy.arn
  role       = aws_iam_role.oidc-role.name
}


data "aws_eks_cluster_auth" "cluserAuth" {
  name = var.cluster-name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluserAuth.token
}

resource "kubernetes_service_account" "k8s-service-account" {
  metadata {
    name      = "aws-alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.oidc-role.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
