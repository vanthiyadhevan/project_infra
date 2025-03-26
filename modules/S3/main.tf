# provider "aws" {
#   region = var.region
# }

# Terraform State Files Storing Bucket for All Different Environment
resource "aws_s3_bucket" "s3_tf_state_file" {
  # region = var.region
  bucket = "${lower(var.bucket[var.environment])}-vnc"

  tags = {
    Name        = "${var.environment}-bucket-state-file-chatapp"
    Environment = var.environment
  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# resource "aws_s3_bucket_acl" "visibility_of_content" {
#   bucket = aws_s3_bucket.s3_tf_state_file.id
#   acl    = var.visibility
# }
resource "aws_s3_bucket_versioning" "bucket_version" {
  bucket = aws_s3_bucket.s3_tf_state_file.id
  versioning_configuration {
    status = var.status
  }
}



# Test Report files bucket 
resource "aws_s3_bucket" "report_storing" {
  bucket = "${lower(var.environment)}-bucket-test-reports-chatapp"

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name        = "${var.environment}-bucket-test-reports-chatapp"
    Environment = var.environment
  }
}

# resource "aws_s3_bucket_acl" "visibility_of_report" {
#   bucket = aws_s3_bucket.report_storing.id
#   acl    = var.visibility
# }

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

# resource "aws_s3_bucket_policy" "report_file_access_policy" {
#   bucket = aws_s3_bucket.report_storing.id
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           # "Principal" : "*",
#           "Action" : [
#             "s3:GetObject",
#             "s3:ListBucket"
#           ],
#           "Resource" : [
#             "arn:aws:s3:::${aws_s3_bucket.report_storing.arn}",  # Bucket ARN
#             "arn:aws:s3:::${aws_s3_bucket.report_storing.arn}/*" # Object ARN within the bucket
#           ]
#         }
#       ]
#     }

#   )
# }
