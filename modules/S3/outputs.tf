# bucket state file output
output "bucket_id" {
  description = "bucket id for the state file"
  value       = aws_s3_bucket.s3_tf_state_file.id
}
output "bucket_name" {
  description = "state file bucket name"
  value       = aws_s3_bucket.s3_tf_state_file.bucket_domain_name
}
output "bucket_arn" {
  description = "bucket arn for future reference for state file"
  value       = aws_s3_bucket.s3_tf_state_file.arn
}
output "bucket_region_state_file" {
  description = "bucket region for state file"
  value       = aws_s3_bucket.s3_tf_state_file.region
}
output "bucket_url_for_state_file" {
  description = "bucket url for state file"
  value       = "https://${aws_s3_bucket.s3_tf_state_file.bucket}.s3.amazonaws.com"
}
# output "bucket_policy_for_state_file" {
#   description = "bucket policy for state file"
#   value       = aws_s3_bucket.s3_tf_state_file.policy
# }


# bucket report file output
output "report_bucket_name" {
  description = "report file bucket name"
  value       = aws_s3_bucket.report_storing.bucket_domain_name
}
output "bucket_id_for_report" {
  description = "bucket id for the report file"
  value       = aws_s3_bucket.report_storing.id
}
output "bucket_arn_for_report" {
  description = "bucket arn for future reference for report file"
  value       = aws_s3_bucket.report_storing.arn
}
output "bucket_region_for_report" {
  description = "bucket region for report file"
  value       = aws_s3_bucket.report_storing.region
}
output "bucket_url_for_report" {
  description = "bucket url for report file"
  value       = "https://${aws_s3_bucket.report_storing.bucket}.s3.amazonaws.com"
}
# output "bucket_policy_for_report_file" {
#   description = "bucket policy for report file"
#   value       = aws_s3_bucket.report_storing.policy
# }


