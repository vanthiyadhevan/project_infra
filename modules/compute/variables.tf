variable "environment" {
  type        = string
  default     = "staging"
  description = "env for all different env's"
}
# Key Pair For All the instance Access
variable "key_pair_name" {
  type        = string
  default     = "mr_skyline_linux"
  description = "key_pair for all the instances"
}
# Testing the security group
variable "my_ip" {
  type        = string
  description = "my router ip"
}
# vpc for all
variable "vpc_id" {
  type = string
  description = "vpc id for all"
}
variable "pub_subnet" {
  type = string
  description = "for all the subets"
}

# Ami's For All The Server Instances
variable "amis" {
  type        = list(string)
  default     = ["ami-084568db4383264d4", "ami-08b5b3a93ed654d19"]
  description = "list of ami's from us-east-1"
}
# Instance Types for all the Servers
variable "inst_type" {
  type    = list(string)
  default = ["t3.medium", "t2.micro"]
}
# Volume size all type of instances
variable "volume_size" {
  type        = list(number)
  default     = [10, 15, 20]
  description = "volume size for all the instance"
}


# sonar qube variable section
variable "sonar_qube_server_name" {
  type        = string
  default     = "sonar_server"
  description = "for code analysis"
}

# jump host server name
variable "jump_host_name" {
  type        = string
  default     = "jump_server"
  description = "to connect all the server's for troubleshooting"
}
variable "jump_host_sg_name" {
  type        = string
  default     = "jump_host"
  description = "to connect all the server's for troubleshooting"
}
# -----------------------
# jenkins security group
# -----------------------
variable "jenkins_sec_grp_name" {
  type        = string
  default     = "jenkins-SG"
  description = "jenkins security group"
}
variable "jenkins_port" {
  type        = number
  default     = 8080
  description = "jenkins access port"
}
variable "ip_protocol_name" {
  type        = string
  default     = "tcp"
  description = "acess protocol"
}
# --------------------
# Jenkins server name
# --------------------
variable "jenkins_server_name" {
  type        = string
  default     = "jenkins_sever"
  description = "for run ci/cd pipeline"
}

# -----------------------------------
# Jenkins Role and Policy Creataion
# -----------------------------------
variable "jenkins_insta_profile_name" {
  type        = string
  default     = "jenkins-instance-profile"
  description = "jenkins instance profile name"
}
variable "jenkins_s3_role_name" {
  type        = string
  default     = "jenkinsS3Role"
  description = "access the bucket for report store"
}
variable "jenkins_s3_policy_name" {
  type        = string
  default     = "jenkinsS3Policy"
  description = "policy for jenkins access the s3 bucket"
}
variable "jenkins_s3_attach_name" {
  type        = string
  default     = "jenkinss3attach"
  description = "attache the role and policy arn to jenkins"
}
# -----------------------------
# ecr role and policy creation
# -----------------------------
variable "jenkins_ecr_role_name" {
  type        = string
  default     = "ecr-role"
  description = "ecr role name"
}

# sonar qube security group
variable "sonar_qube_name" {
  type        = string
  default     = "sonar-qube"
  description = "sonar qube security group name"
}
variable "sonar_port" {
  type        = string
  default     = "9000"
  description = "sonar qube accessing port"
}


# SSH Access for all the servers
variable "ssh_access_for_sg" {
  type        = number
  default     = 22
  description = "ssh access for security group"
}