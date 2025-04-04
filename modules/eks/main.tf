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
# Create IAM Policy for AssumeRole
# resource "aws_iam_policy" "eks_assume_role_policy" {
#   name        = "eks-assume-role-policy"
#   description = "Allows users in the group to assume the eks-admins-role"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = "sts:AssumeRole"
#         Resource = "arn:aws:iam::605134458717:role/${aws_iam_role.eks-role.name}"
#       }
#     ]
#   })
# }
# Minimum Requirment of EKS
resource "aws_eks_cluster" "chatApp_cluster" {
  name = "${var.environment}-${var.eks_cluster_name}-eks"
  # role_arn = aws_iam_role_policy_attachment.chatApp-AmazonEKSClusterPolicy.policy_arn
  role_arn = aws_iam_role.eks-role.arn
  # endpoint = true

  # cluster_endpoint_public_access = var.boolvalue

  version = var.cluster_version
  # vpc_config {
  #   subnet_ids = [
  #     aws_subnet.pub_subnet.*.id,
  #     aws_subnet.pvt_subnet.*.id
  #   ]
  # }
  vpc_config {
    subnet_ids = var.pvt_subnet
    # subnet_ids = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
    # subnet_ids = [
    #   data.aws_subnets.public[*].id,
    #   data.aws_subnets.private[*].id
    # ]
  }
  depends_on = [
    aws_iam_role_policy_attachment.chatApp-AmazonEKSClusterPolicy
    # aws_iam_openid_connect_provider.eks_oidc_connector
  ]
}


data "tls_certificate" "eks_tls" {
  url = aws_eks_cluster.chatApp_cluster.identity[0].oidc[0].issuer
}
resource "aws_iam_openid_connect_provider" "eks_oidc_connector" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.chatApp_cluster.identity[0].oidc[0].issuer

  depends_on = [ aws_eks_cluster.chatApp_cluster ]
}


# For Data Sourcing purpose and testing EKS CLUSTER
# # get public subnets 
# data "aws_subnets" "public" {
#   filter {
#     name   = "tag:Name"
#     values = ["*prod-pub-subnet*"] # Modify based on your naming convention
#   }
# }

# # get private subnets
# data "aws_subnets" "private" {
#   filter {
#     name   = "tag:Name"
#     values = ["*prod-pvt-subnet*"]
#   }
# }

