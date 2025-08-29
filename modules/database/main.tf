

# RDS Instance
resource "aws_db_instance" "RDS_instance" {
  identifier              = "${var.db_engine}-db"
  engine                  = var.db_engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  multi_az                = var.multi_az
  username                = var.username
  password                = var.password
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  db_subnet_group_name    = aws_db_subnet_group.RDS_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  storage_encrypted       = true
  deletion_protection     = var.deletion_protection

  skip_final_snapshot     = var.deletion_protection ? false : true
#   depends_on = [
#     aws_db_subnet_group.RDS_subnet_group
#   ]
  tags = {
    Name = "${var.db_engine}-db"
  }
}
