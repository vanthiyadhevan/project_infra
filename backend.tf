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
# terraform {
#   backend "s3" {
#     bucket = "${var.environment}-${var.name_of_bucket}"
#     key    = "${var.environment}-${var.state_key_file}"
#     # use_lockfile = "${var.environment}-${var.backend_db_name}"
#     # use_lockfile = true
#     encrypt = true
#     region  = var.region
#   }
# }

terraform {
  backend "s3" {
    bucket  = "staging-state-file-vnc"
    key     = "terraform/staging/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

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
