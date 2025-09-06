variable "vpc_id" {
  type        = string
  description = "VPC ID where compute resources will be created"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for placing the Application Load Balancer"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for placing EC2 instances in the Auto Scaling Group"
}

variable "app_port" {
  type        = number
  default     = 80
  description = "Port the application will listen on (e.g., 80 or 8080)"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for app servers"
}

variable "desired_capacity" {
  type        = number
  default     = 2
  description = "Number of EC2 instances to launch by default"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
}

variable "max_size" {
  type        = number
  default     = 4
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
}


variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to compute resources"
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "Optional ACM certificate ARN for enabling HTTPS on the ALB"
}

variable "allow_ssh_cidr" {
  type        = string
  default     = ""
  description = "Optional CIDR block to allow SSH access (leave empty to disable)"
}

variable "project" {
  type        = string
  default     = "HUG-IB"
  description = "Project name for resource naming"
}
variable "user_data" {
  description = "EC2 user data script"
  default = <<-EOF
    #!/bin/bash
    # Install and start a simple web server
    yum install -y httpd
    systemctl enable httpd
    systemctl start httpd
    echo "healthy" > /var/www/html/health
  EOF
}
