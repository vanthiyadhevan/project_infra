# Role For NodeGroup
resource "aws_iam_role" "node_grp_role" {
  name = var.node_grp_role_name
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
    tag-key = "eks-WorkerNode"
  }
}

# IAM Policy Attachement For NodeGroup 

resource "aws_iam_role_policy_attachment" "nodeGroup_policy_attach" {
  #   name = var.node_grp_role_name
  role       = aws_iam_role.node_grp_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  role = var.node_grp_role_name
  # name = var.node_grp_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  role       = var.node_grp_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

# AWS node group 

resource "aws_eks_node_group" "pvt_node" {
  cluster_name  = aws_eks_cluster.chatApp_cluster.name
  node_role_arn = aws_iam_role.node_grp_role.arn
  subnet_ids    = aws_subnet.pvt_subnet[*].id
  scaling_config {
    desired_size = 4
    max_size     = 3
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "kubenode02-${var.environment}"
  }

  depends_on = [aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodeGroup_policy_attach,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy
  ]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}