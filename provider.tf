terraform {
  backend "s3" {
    region = var.region
    bucket = aws_s3_bucket.s3_tf_state_file.id
    key = var.key_file

  }
}
provider "aws" {
  region = var.region
}