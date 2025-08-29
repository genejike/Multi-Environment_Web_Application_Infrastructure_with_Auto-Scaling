output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

# Optional: If you create common security groups here (e.g., for ALB or DB)
# output "alb_sg_id" {
#   description = "Security Group ID for ALB (if created in networking)"
#   value       = aws_security_group.alb_sg.id
# }

# output "db_sg_id" {
#   description = "Security Group ID for database (if created in networking)"
#   value       = aws_security_group.db_sg.id
# }
# output "nat_gateway_ids" {
#   description = "List of NAT Gateway IDs"
#   value       = aws_nat_gateway.this[*].id
# }