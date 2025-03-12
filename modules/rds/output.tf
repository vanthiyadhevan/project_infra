output "rds_instance_name" {
  value = aws_db_instance.database.db_name
}
output "dynamo_db_table" {
  value = aws_dynamodb_table.dynamodb_for_state_lock.id
}
output "availability_zone" {
  value = aws_db_instance.database.availability_zone
}
output "status" {
  value = aws_db_instance.database.status
}