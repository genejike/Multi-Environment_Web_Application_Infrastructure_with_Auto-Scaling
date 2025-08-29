# Subnet group
resource "aws_db_subnet_group" "RDS_subnet_group" {
  name       = "${var.db_engine}-subnet-group"
  subnet_ids = var.private_subnet_ids
lifecycle {
    prevent_destroy = false
  }
  tags = {
    Name = "${var.db_engine}-subnet-group"
  }
}

# DB Security Group
resource "aws_security_group" "db_sg" {
  name        = "${var.db_engine}-db-sg"
  description = "Allow DB access from app SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_engine}-db-sg"
  }
}