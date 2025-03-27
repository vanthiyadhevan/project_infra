output "eks_cluster_autoscaler_arn" {
  value       = aws_iam_role.eks_cluster_autoscaler.arn
  description = "cluster arn"
}
output "eks_cluster_id" {
  value       = aws_eks_cluster.chatApp_cluster.id
  description = "eks cluster id"
}
output "eks_cluster_name" {
  value       = aws_eks_cluster.chatApp_cluster.name
  description = "eks cluster name"
}
output "eks_cluster_certificate_authority" {
  value       = aws_eks_cluster.chatApp_cluster.certificate_authority
  description = "eks cluster certificate authority"
}
output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.chatApp_cluster.endpoint
  description = "eks cluster endpoint"
}
# output "eks_cluster_security_group_id" {
#   value       = aws_eks_cluster.chatApp_cluster.cluster_security_group_id
#   description = "default cluster security group id"
# }