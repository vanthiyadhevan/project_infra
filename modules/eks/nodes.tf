# Role For NodeGroup
resource "aws_iam_role" "node_grp_role" {
  name = "${var.environment}-${var.node_grp_role_name}"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    }
  )
  tags = {
    Name        = "${var.environment}-EKS-WorkerNode"
    Environment = var.environment
  }
}


# IAM Policy Attachement For NodeGroup 
resource "aws_iam_role_policy_attachment" "nodeGroup_policy_attach" {
  role       = aws_iam_role.node_grp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_grp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_grp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

# AWS node group 

resource "aws_eks_node_group" "pvt_node" {
  cluster_name    = aws_eks_cluster.chatApp_cluster.name
  node_group_name = "${var.environment}-${var.node_name}"
  node_role_arn   = aws_iam_role.node_grp_role.arn
  # subnet_ids      = aws_subnet.pvt_subnet[*].id
  subnet_ids = var.pvt_subnet
  # subnet_ids = [
  #   data.aws_subnets.private.ids,
  #   data.aws_subnets.public.ids
  # ]
  # subnet_ids = concat(data.aws_subnets.private.ids, data.aws_subnets.public.ids)
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  # instance_types = var.instan_type

  update_config {
    max_unavailable = 1
  }

  labels = {
    node = "${var.environment}-k8snode"
  }

  depends_on = [aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodeGroup_policy_attach,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy
  ]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

