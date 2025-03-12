terraform {
  backend "s3" {
    bucket         = "staging-bucket-${var.environment}"
    key            = "state/${var.environment}/terraform.tfstate"
    dynamodb_table = "terraform-lock-${var.environment}"
    encrypt        = true
    region         = var.region
  }
}