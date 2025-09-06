output "vpc_id" {
  value = module.networking.vpc_id
}
output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}
output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}
output "alb_dns_name" {
  value = module.compute.alb_dns_name
}
output "alb_security_group_id" {
  value = module.compute.alb_security_group_id
}
output "asg_name" {
  value = module.compute.asg_name
}
output "target_group_arn" {
  value = module.compute.target_group_arn
}
output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_identifier" {
  value = module.database.db_identifier
}
