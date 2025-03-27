# All Kind Of Environment 
variable "environment" {
  type        = string
  default     = "staging"
  description = "for all different environment"
}
# VPC Related variables
variable "vpc_id" {
  description = "VPC ID."
  type        = string
  # default = var.vpc_id
}
variable "vpc_cidr" {
  description = "VPC CIDR_BLOCK"
  type        = string
  # default = var.vpc_cidr
}
variable "pub_subnet" {
  description = "Public subnets"
  type        = list(string)
}
variable "pvt_subnet" {
  description = "private subnets"
  type        = list(string)
}



# ------------------------
# CLUSTER SECTION
# ------------------------
# Cluster role name
variable "cluster_role_name" {
  type        = string
  default     = "CustomEKSClusterRole"
  description = "custom ekscluster name for all different Environment"
}
# Name Of The Cluster
variable "eks_cluster_name" {
  type        = string
  default     = "chatApp"
  description = "Name of the cluster"
}
# Cluster Version 
variable "cluster_version" {
  type        = string
  default     = "1.31"
  description = "Version the cluster we use in this projec"
}
# ------------------------
# NODE GROUP SECTION START
# ------------------------

# Node Role name
variable "node_grp_role_name" {
  type        = string
  default     = "CustomEKSNodeGroup"
  description = "node group role name"
}
# Node group name
variable "node_name" {
  type        = string
  default     = "workernode"
  description = "node name"
}

# instance_types of pod
variable "instan_type" {
  type        = string
  default     = "t3.small"
  description = "instance type of pods"
}

# --------------------------
# EKS cluster autoscaler
# --------------------------

variable "eks_cluster_autoscaler_name" {
  type        = string
  default     = "cluser_auto_role"
  description = "eks cluster autoscaler name"
}