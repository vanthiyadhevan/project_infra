variable "environment" {
  type        = string
  default     = "staging"
  description = "for all different environment"
  nullable    = false
}
variable "my_ip" {
  type        = string
  description = "my router ip"
}
# variable "rds_sg_name" {
#     type = string
#     default = "db_insta_sg"
#     description = "rds db instance sg for all enviroment"
# }

# -----------------------------------
# Jenkins security group variables
# -----------------------------------

# Name of jenkins security group
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


# jumb host security group
variable "jump_host_name" {
  type        = string
  default     = "jumb_host-SG"
  description = "Jump host security group"
}
variable "ssh_access_for_sg" {
  type        = number
  default     = 22
  description = "ssh access for security group"
}


# sonar qube security group
variable "sonar_qube_name" {
  type        = string
  default     = "sonar_qube-SG"
  description = "sonar qube security group name"
}
variable "sonar_port" {
  type        = number
  default     = 9000
  description = "sonar qube accessing port"
}

