# SNS topic for alerts
resource "aws_sns_topic" "alerts" {
  name = "infra-alerts"
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

# 🔹 ALB 5XX Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "ALB-5XX-Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 5
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  statistic           = "Sum"
  period              = 300
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = var.tags
}

# 🔹 ASG High CPU
resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "ASG-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 70
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = var.tags
}

# 🔹 RDS Low Free Storage
resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name          = "RDS-Low-Free-Storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 2000 # MB
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  period              = 300
  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
  tags          = var.tags
}
