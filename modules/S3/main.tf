provider "aws" {
  region = var.region
}
# -------------------------------------------------------------------
# This S3 bucket is used to store the terraform state file
# Terraform State Files Storing Bucket for All Different Environment
# -------------------------------------------------------------------
resource "aws_s3_bucket" "s3_tf_state_file" {
  bucket = "${lower(var.bucket)}-vnc"

  tags = {
    Name        = "${var.environment}-state-file-chatapp"
    Environment = var.environment
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}


resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.s3_tf_state_file.id
  versioning_configuration {
    status = var.status
  }
}


# -------------------------------------------------------------------
# This S3 bucket is used to store the Jenkins Test Report files
# Terraform Test Report Files Storing Bucket for All Different Environment
# -------------------------------------------------------------------
resource "aws_s3_bucket" "report_storing" {
  bucket = "${lower(var.environment)}-test-reports-chatapp"

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name        = "${var.environment}-bucket-test-reports-chatapp"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "report_storing_version" {
  bucket = aws_s3_bucket.report_storing.id
  versioning_configuration {
    status = var.status
  }
}

resource "aws_s3_bucket_public_access_block" "disable_public_block" {
  bucket = aws_s3_bucket.report_storing.id

  block_public_acls       = false
  block_public_policy     = false # Allow setting bucket policies
  ignore_public_acls      = false
  restrict_public_buckets = false
}

