# All Kind Of Environment 
variable "environment" {
  type        = string
  default     = "staging"
  description = "for all different environment"
}

# Name of the policy
variable "name_of_policy" {
  type        = string
  default     = "EksClusterPolicy"
  description = "name of the policy"
}

# Name Of The Cluster
variable "eks_cluster_name" {
  type    = string
  default = "chatApp"
}


# ------------------------
# NODE GROUP SECTION START
# ------------------------

variable "node_grp_role_name" {
  type        = string
  default     = "NodeGroupEks"
  description = "node group role name"
}

# --------------------------
# EKS cluster autoscaler
# --------------------------

variable "eks_cluster_autoscaler_name" {
  type = string
  default = "cluser_auto_role"
  description = "eks cluster autoscaler name"
}