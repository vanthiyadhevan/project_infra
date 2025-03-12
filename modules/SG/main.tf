resource "aws_db_instance_group" "rds_db_sg" {
  name = "${var.rds_sg_name}-${var.environment}-SG"

  ingress {
    cidr = ""
  }
}