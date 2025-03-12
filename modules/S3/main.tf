provider "aws" {
  region = var.region
}

# Terraform State Files Storing Bucket for All Environment
resource "aws_s3_bucket" "s3_tf_state_file" {
  # region = var.region
  bucket = var.bucket[var.environment]

  tags = {
    Name        = "${var.environment}-bucket-state-file"
    Environment = var.environment
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_s3_bucket_acl" "visibility_of_content" {
  bucket = aws_s3_bucket.s3_tf_state_file.id
  acl    = var.visibility
}
resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.s3_tf_state_file.id
  versioning_configuration {
    status = var.status
  }
}



# Test Report files bucket 
resource "aws_s3_bucket" "report_storing" {
  bucket = "${var.environment}-bucket-test-reports"

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name        = "${var.environment}-bucket-test-reports"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_acl" "visibility_of_report" {
  bucket = aws_s3_bucket.report_storing.id
  acl    = var.visibility
}

resource "aws_s3_bucket_versioning" "report_storing_version" {
  bucket = aws_s3_bucket.report_storing.id
  versioning_configuration {
    status = var.status
  }
}
