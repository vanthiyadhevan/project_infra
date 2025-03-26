# REGION FOR THIS APPLICATION
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region is used to deploy this application"
}
# ENVIRONMET FOR ALL DIFFERNRT ENVRIONMENT
# variable "environment" {
#   type        = string
#   default     = "staging"
#   description = "for all the environments"
# }

# STATE FILE STOREING
variable "key_file" {
  type        = string
  default     = "terraform/terraform.tfstate"
  description = "terraform state file name and location"
}

variable "aws_account_id" {
  sensitive   = true
  type        = string
  default     = ""
  description = "account"
}
variable "my_ip" {
  type        = string
  description = "my router ip"
}



# BACKEND FILE VARIABLES
# variable "name_of_bucket" {
#   type        = string
#   default     = "bucket-state-file"
#   description = "bucket name for all environment state file"
# }
# variable "state_key_file" {
#   type        = string
#   default     = "state-file"
#   description = "State file name all different environment"
# }
# variable "backend_db_name" {
#   type        = string
#   default     = "terraform-lock"
#   description = "state locking file name for all different environment"
# }