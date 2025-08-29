variable "vpc_id" {
  type        = string
  description = "VPC ID where the DB will be deployed"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the DB subnet group"
}

variable "db_engine" {
  type        = string
  description = "Database engine (e.g., mysql, postgres)"
}

variable "engine_version" {
  type        = string
  description = "DB engine version (e.g., 8.0, 14.6)"
}

variable "instance_class" {
  type        = string
  description = "RDS instance type (e.g., db.t3.micro)"
}

variable "allocated_storage" {
  type        = number
  description = "Storage size in GB"
}

variable "multi_az" {
  type        = bool
  description = "Whether to enable multi-AZ deployment"
}

variable "username" {
  type        = string
  sensitive   = true
  description = "Master DB username (use Secrets Manager ideally)"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Master DB password (use Secrets Manager ideally)"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
}

variable "maintenance_window" {
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
}

variable "deletion_protection" {
  type        = bool
  default     = false
}

variable "app_security_group_id" {
  type        = string
  description = "App security group ID allowed to connect to DB"
}
