output "db_endpoint" {
  value = aws_db_instance.RDS_instance.endpoint
}

output "db_port" {
  value = aws_db_instance.RDS_instance.port
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
output "db_identifier" {
  value = aws_db_instance.RDS_instance.identifier
}

