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
output "eks_cluster_name" {
  value       = module.eks.eks_cluster_name
  description = "eks cluster name"
}
