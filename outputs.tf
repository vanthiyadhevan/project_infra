# ----------------------
# VPC MODULE
# ----------------------
output "vpc_id" {
  value = module.vpc.vpc_id
}
output "pub_subnet" {
  value = module.vpc.pub_subnet
}
output "pvt_subnet" {
  value = module.vpc.pvt_subnet
}

# ------------------------
# EKS CLUSTER MODULE
# ------------------------
# output "eks_cluster_autoscaler_arn" {
#   value = module.eks.eks_cluster_autoscaler_arn.arn
#   # value       = aws_iam_role.eks_cluster_autoscaler.arn
#   description = "cluster arn"
# }
# output "eks_cluster_id" {
#   value = module.eks.eks_cluster_id.id
#   # value       = aws_eks_cluster.chatApp_cluster.id
#   description = "eks cluster id"
# }
# output "eks_cluster_name" {
#   value = module.eks.eks_cluster_name.name
#   # value       = aws_eks_cluster.chatApp_cluster.name
#   description = "eks cluster name"
# }
# output "eks_cluster_certificate_authority" {
#   value = module.eks.eks_cluster_certificate_authority.certificate_authority
#   # value       = aws_eks_cluster.chatApp_cluster.certificate_authority
#   description = "eks cluster certificate authority"
# }
# output "eks_cluster_endpoint" {
#   value = module.eks.eks_cluster_endpoint.endpoint
#   # value       = aws_eks_cluster.chatApp_cluster.endpoint
#   description = "eks cluster endpoint"
# }
# output "eks_cluster_security_group_id" {
#   value = module.eks.eks_cluster_security_group_id.cluster_security_group_id
#   # value       = aws_eks_cluster.chatApp_cluster.cluster_security_group_id
#   description = "default cluster security group id"
# }