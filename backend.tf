# VAriable for checking purpose
variable "name_of_bucket" {
  type        = string
  default     = "bucket-state-file"
  description = "bucket name for all environment state file"
}
variable "state_key_file" {
  type        = string
  default     = "state-file"
  description = "State file name all different environment"
}
variable "backend_db_name" {
  type        = string
  default     = "terraform-lock"
  description = "state locking file name for all different environment"
}
# variable "region" {
#   type        = string
#   default     = "us-east-1"
#   description = "region is used to deploy this application"
# }
variable "environment" {
  type        = string
  default     = "staging"
  description = "for all the environments"
}
# terraform {
#   backend "s3" {
#     bucket         = "staging-bucket-${var.environment}"
#     key            = "state/${var.environment}/terraform.tfstate"
#     dynamodb_table = "terraform-lock-${var.environment}"
#     encrypt        = true
#     region         = var.region
#   }
# }

# Define the backend for storing the Terraform state
terraform {
  backend "s3" {
    bucket = "${var.environment}-${var.name_of_bucket}"
    key    = "${var.environment}-${var.state_key_file}"
    # use_lockfile = "${var.environment}-${var.backend_db_name}"
    use_lockfile = true
    encrypt      = true
    region       = var.region
  }
}

# terraform {
#   backend "s3" {
#     bucket = "bucket-state-file"
#     key    = "state-file"
#     # dynamodb_table = "terraform-lock"
#     use_lockfile = true
#     region       = "us-east-1"
#     encrypt      = true
#   }
# }

# Reference the remote state from an S3 bucket
# data "terraform_remote_state" "state" {
#   backend = "s3"
#   config = {
#     bucket         = "${var.environment}-${var.name_of_bucket}"
#     key            = "${var.environment}-${var.state_key_file}"
#     dynamodb_table = "${var.environment}-${var.backend_db_name}"
#     encrypt        = true
#     region         = "${var.region}"
#   }
# }
