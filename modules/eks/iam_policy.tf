resource "aws_iam_role" "eks-role" {
  name = var.name_of_policy
  assume_role_policy = jsondecode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "stsAssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        }
      ]
    }
  )
  tags = {
    tag-key = "eks-cluster"
  }
}

# EKS Policy Attachment
resource "aws_iam_role_policy_attachment" "chatApp-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

# Minimum Requrment of EKS

resource "aws_eks_cluster" "chatApp_cluster" {
  name     = "${var.eks_cluster_name.var.environment}-eks"
  role_arn = aws_iam_role_policy_attachment.chatApp-AmazonEKSClusterPolicy.policy_arn

  vpc_config {
    subnet_ids = [
      aws_subnet.pub_subnet[*].id,
      aws_subnet.pvt_subnet[*].id
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.chatApp-AmazonEKSClusterPolicy]
}