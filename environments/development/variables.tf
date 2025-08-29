variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  
}
variable "enable_nat_per_az" {
  description = "Enable NAT Gateway in each AZ (true) or single NAT Gateway (false)"
  type        = bool
  default     = false
}
variable "username" {
  description = "Username for the EC2 instance"
  type        = string
  
}
variable "password" {
  description = "Password for the EC2 instance"
  type        = string 
  
}

variable "instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
  
}