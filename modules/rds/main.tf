# This RDS for terraform state locking purpose

# data "aws_secretsmanager_random_password" "tf_state_lock" {
#   password_length = 50
# }
resource "aws_db_instance" "database" {
  identifier        = "tf-state-lock"
  instance_class    = var.db_class_type
  db_name           = var.rds_database_name
  allocated_storage = var.db_allocated_size
  username          = var.db_username
  # password            = data.aws_secretsmanager_random_password.tf_state_lock.secret_string
  password            = var.password
  engine              = var.engine
  engine_version      = var.engine_version
  publicly_accessible = false
  # manage_master_user_password = true
  # vpc_security_group_ids = [modules.vpc.aws_vpc.vpc_main.id]
  # db_subnet_group_name   = modules.vpc.aws_db_subnet_group.pvt_db_subnet_grp.id

  # lifecycle {
  #   prevent_destroy = true
  # }
  # Allow RDS deletion without requiring a final snapshot
  skip_final_snapshot = true

  tags = {
    Name        = "tf-state-lock-${var.environment}"
    Environment = var.environment
  }
}
