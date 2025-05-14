# -------------------------------------------------------------
# EKS Cluster complete Creation with Role and Role Attachment
# -------------------------------------------------------------

# EKS Cluster Role
resource "aws_iam_role" "eks-role" {
  name = "${var.environment}-${var.cluster_role_name}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }
      ]
    }
  )
  tags = {
    # tag-key = "eks-cluster"
    Name        = "${var.environment}-EKSCluster"
    Environment = var.environment
  }
}

# EKS Policy Attachment
resource "aws_iam_role_policy_attachment" "chatApp-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks-role.name
  policy_arn = var.eks_policy_arn
  depends_on = [aws_iam_role.eks-role]
}
resource "aws_iam_role_policy_attachment" "chatApp-AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks-role.name
  policy_arn = var.eks_service_policy_arn
  depends_on = [aws_iam_role.eks-role]
}

# Minimum Requirment of EKS
resource "aws_eks_cluster" "chatApp_cluster" {
  name = "${var.environment}-${var.eks_cluster_name}-eks"
  role_arn = aws_iam_role.eks-role.arn
  version = var.cluster_version
  vpc_config {
    subnet_ids = var.pvt_subnet
  }
  depends_on = [
    aws_iam_role_policy_attachment.chatApp-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.chatApp-AmazonEKSServicePolicy
  ]
}


data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.chatApp_cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks_oidc_connector" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.chatApp_cluster.identity[0].oidc[0].issuer

  depends_on = [aws_eks_cluster.chatApp_cluster]
}


