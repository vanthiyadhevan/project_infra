# REGION FOR THIS APPLICATION
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region is used to deploy this application"
}
# ENVIRONMET FOR ALL DIFFERNRT ENVRIONMENT
variable "environment" {
  type        = string
  default     = "staging"
  description = "for all the environments"
}


variable "my_ip" {
  type        = string
  description = "my router ip"
}

