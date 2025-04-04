data "aws_iam_policy_document" "eks_cluster_autoscaler_assume_role_policy" {
  statement {
    sid = "1"
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
      variable = "${replace(aws_iam_openid_connect_provider.eks_oidc_connector.url, "https://", "")}:sub"
    }
    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_oidc_connector.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_assume_role_policy.json
  name               = "${var.environment}-eks-cluster-autoscaler"
}

resource "aws_iam_policy" "eks_cluster_autoscaler_policy" {
  name = var.eks_cluster_autoscaler_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "autoscaling:DescribeAutoScalingGroup",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role       = aws_iam_role.eks_cluster_autoscaler.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler_policy.arn

}