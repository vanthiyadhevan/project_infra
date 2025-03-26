provider "aws" {
  region = var.region
}
# terraform {
#   backend "s3" {
#     bucket         = "${var.environment}-${var.name_of_bucket}"
#     key            = "${var.environment}/${var.state_key_file}"
#     dynamodb_table = "${var.environment}-${var.backend_db_name}"
#     encrypt        = true
#     region         = var.region
#   }
# }

# terraform {
# 	backend "s3" {}
# }
# data "terraform_remote_state" "state" {
# 	backend = "s3"
# 	config {
# 		bucket = "${var.environment}-${var.name_of_bucket}"
# 		key = "$${var.environment}-${var.state_key_file}"
# 		dynamodb_table = "${var.environment}-${var.backend_db_name}"
# 		encrypt = true
# 		region = "${var.region}"
# 	}
# }