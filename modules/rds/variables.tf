# Environment Selection
variable "environment" {
  type        = string
  default     = "staging"
  description = "for different environment"
  nullable    = false
}
# Region to create RDS
variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region used to store the TF-state files"
}
variable "rds_database_name" {
  type        = string
  default     = "tfstatelockdb"
  description = "rds table name"
}
variable "db_allocated_size" {
  type        = number
  default     = 5
  description = "size of the db storage"

}
variable "db_class_type" {
  type        = string
  default     = "db.t3.micro"
  description = "db instance type"

}
variable "db_username" {
  type        = string
  default     = "vickey"
  description = "username of db to login "

}
variable "password" {
  sensitive   = true
  type        = string
  default     = "sdfDFDsl83eh"
  description = "db instance password"
}
variable "engine" {
  type        = string
  default     = "mysql"
  description = "type of the db mysql"
}
variable "engine_version" {
  type        = string
  default     = "8.0"
  description = "mysql version in used in application"
}


# Backend file variable





# DynamoDB TF_file variables
variable "db_table_name" {
  type        = string
  default     = "terraform-lock"
  description = "dynamo db table name"
}
variable "bill_mode" {
  type        = list(string)
  default     = ["PROVISIONED", "PAY_PER_REQUEST"]
  description = "billiing mode"
}
variable "name_and_hash_key" {
  type        = string
  default     = "LockID"
  description = "hash key and attributes value=name"
}
variable "read_cap" {
  type        = list(number)
  default     = [1, 5, 10]
  description = "read capacity of the dynamodb"
}
variable "write_cap" {
  type        = list(number)
  default     = [1, 5, 10]
  description = "write capacity of the dynamodb"
}