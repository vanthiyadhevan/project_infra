output "bucket_id" {
  value = aws_s3_bucket.s3_tf_state_file.id
}
output "bucket_name" {
  value = aws_s3_bucket.s3_tf_state_file.bucket_domain_name
}
output "report_bucket_name" {
  value = aws_s3_bucket.report_storing.bucket_domain_name
}
