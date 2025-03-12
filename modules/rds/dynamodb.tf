resource "aws_dynamodb_table" "dynamodb_for_state_lock" {
  name           = var.db_table_name
  billing_mode   = var.bill_mode[0]
  hash_key       = var.name_and_hash_key
  read_capacity  = var.read_cap[0]
  write_capacity = var.write_cap[0]
  attribute {
    name = var.name_and_hash_key
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-lock-${var.environment}"
    Environment = var.environment
  }

}