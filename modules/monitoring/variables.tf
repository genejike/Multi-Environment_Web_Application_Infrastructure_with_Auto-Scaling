variable "alb_arn_suffix" {
  description = "ARN suffix for the ALB (used in CloudWatch metrics)"
  type        = string
}

variable "asg_name" {
  description = "AutoScaling Group name"
  type        = string
}

variable "db_identifier" {
  description = "RDS DB instance identifier"
  type        = string
}

variable "sns_email" {
  description = "Email address for SNS notifications"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
