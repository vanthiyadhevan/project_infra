# REGION FOR THIS APPLICATION
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region is used to deploy this application"
}
# STATE FILE STOREING
variable "key_file" {
  type        = string
  default     = "terraform.d/terraform.tfstate"
  description = "terraform state file name and location"
}
