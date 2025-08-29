
variable "vpc_cidr" {
  description = "The VPC CIDR block"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The public subnet CIDR blocks"
  type        = list(string)

}

variable "private_subnet_cidrs" {
  description = "The private subnet CIDR blocks"
  type        = list(string)
}

variable "enable_nat_per_az" {
  description = "Whether to create a NAT Gateway per AZ (true = HA, false = single NAT)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    project     = "web-platform"
  }
}


