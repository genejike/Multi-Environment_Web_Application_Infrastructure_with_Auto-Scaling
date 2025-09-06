# MULTI_ENVIRONMENT WEB APPLICATION

A STEP BY STEP GUIDE

Build modules/networking

Inputs you’ll define in variables.tf:

 vpc_cidr (string)

 public_subnet_cidrs (list(string), ≥ 2 AZs)

 private_subnet_cidrs (list(string), ≥ 2 AZs)

 (Optional) enable_nat_per_az (bool), tags (map(string))

Resources in main.tf:

 aws_vpc (DNS hostnames/support enabled).

 aws_internet_gateway.

 aws_subnet (public) across 2 AZs.

 aws_subnet (private) across 2 AZs.

 aws_eip and aws_nat_gateway (one per AZ or single for dev).

 aws_route_table + associations for public subnets (0.0.0.0/0 → IGW).

 aws_route_table + associations for private subnets (0.0.0.0/0 → NAT).

 Security groups (optional if you prefer them in compute/db modules).

Outputs (outputs.tf):

 vpc_id

 public_subnet_ids

 private_subnet_ids

 (Optional) common SG IDs if created here.

4) Build modules/compute

Inputs (variables.tf):

 vpc_id (string)

 public_subnet_ids (list(string)) — for ALB

 private_subnet_ids (list(string)) — for ASG

 app_port (number, e.g., 80)

 instance_type (string, e.g., t3.micro)

 desired_capacity, min_size, max_size (numbers)

 (Optional) user_data (string), tags (map(string))

 (Optional) certificate_arn if you want HTTPS on ALB

 (Optional) allow_ssh_cidr for bastion/ssh if needed

Resources (main.tf):

 ALB (aws_lb) in public subnets, internal = false, with an ALB security group allowing 80/443 from 0.0.0.0/0.

 Target Group (aws_lb_target_group) on HTTP:${app_port} with a health check (/, 200–399).

 Listener (aws_lb_listener) on port 80 → forward to TG.
(Optional) another listener on 443 with ACM certificate.

 IAM role + instance profile for EC2 (allow SSM, logs).

 Launch Template:

AMI via SSM parameter (e.g., latest Amazon Linux 2023):
/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64

user_data to install/start your app (or pull from S3/ECR).

Security group for instances that allows inbound from ALB SG on app_port.

 Auto Scaling Group in private subnets, attached to TG, with:

desired_capacity, min_size, max_size

Health check type ELB and grace period (e.g., 60–120s)

 Scaling policies/alarms (e.g., target tracking at 50–60% CPU).

Outputs:

 alb_dns_name

 alb_security_group_id

 asg_name

 target_group_arn

5) Build modules/database

Inputs (variables.tf):

 vpc_id (string)

 private_subnet_ids (list(string))

 db_engine ("mysql"), engine_version (e.g., 8.0)

 instance_class (e.g., db.t3.micro for dev)

 allocated_storage (e.g., 20)

 multi_az (bool; true in prod, false in dev to save cost)

 username (sensitive), password (sensitive)
(Better: pass a Secrets Manager/SSM parameter name instead.)

 backup_retention_period, maintenance_window, backup_window

 deletion_protection (true in prod)

 app_security_group_id to allow MySQL inbound from app

Resources (main.tf):

 aws_db_subnet_group using private subnets.

 aws_security_group for DB allowing 3306 from app SG only.

 (Optional) aws_db_parameter_group.

 aws_db_instance (or aws_rds_cluster if Aurora) with:

Engine/version, class, storage, multi-AZ, backup/maintenance windows

Encrypted at rest, enhanced monitoring (optional)

Subnet group + SG

skip_final_snapshot = false in prod (true in dev if desired)

Outputs:

 db_endpoint

 db_port

 db_sg_id

6) Wire modules in each environment

Inside environments/dev/main.tf and prod/main.tf:

 Call networking module → capture outputs.

 Call compute module → pass vpc_id, public_subnet_ids, private_subnet_ids.

 Call database module → pass vpc_id, private_subnet_ids, and app_security_group_id from compute so DB only allows the app.

 Output useful values (e.g., alb_dns_name, db_endpoint).

7) Define environment variables (terraform.tfvars)

Create values per environment:

environments/dev/terraform.tfvars

 vpc_cidr = "10.0.0.0/16"

 public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

 private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

 instance_type = "t3.micro"

 desired_capacity = 1, min_size = 1, max_size = 2

 db_engine = "mysql", engine_version = "8.0"

 db_instance_class = "db.t3.micro", allocated_storage = 20

 multi_az = false

 backup_retention_period = 1

 (Optional) certificate_arn = "" (omit for HTTP-only dev)

environments/prod/terraform.tfvars

 Larger instance sizes,

 multi_az = true,

 Higher backup_retention_period (e.g., 7–14),

 Scaling limits higher,

 Add certificate_arn for HTTPS,

 Use separate CIDRs (avoid overlap with dev).

8) Plan & apply (per environment)

 cd environments/dev

 terraform init

 terraform fmt && terraform validate

 terraform plan

 terraform apply -auto-approve (optional flag)

 Note the ALB DNS output and visit it in a browser.

 Repeat for environments/prod when ready.

9) Test the app and scaling

 Confirm health checks are healthy on the ALB Target Group.

 Generate load (e.g., hey or ab) against the ALB DNS.

 Watch ASG scale out/in via CloudWatch and EC2 console.

 Verify new instances register healthy behind the ALB.

10) Monitoring & alerts (simple starter)

 CloudWatch Alarms:

ALB HTTPCode_ELB_5XX > 5 for 5 mins → SNS

ASG average CPU > 70% for 10 mins → scale out

RDS FreeStorage < threshold → SNS

 SNS Topic + subscription (email).

 (Optional) Enable ALB access logs to S3.

 (Optional) Add AWS WAF to ALB.

11) Security, networking, and ops polish

 Restrict DB SG to app SG only (no public).

 Restrict instance SG: inbound only from ALB SG on app_port.

 Enforce HTTPS on ALB in prod; redirect 80 → 443.

 Use ACM for certs in the same region as ALB.

 Store DB creds in AWS Secrets Manager or SSM Parameter Store, not in plain tfvars.

 Add resource tags (env, app, owner, cost-center).

 (Optional) Private bastion/SSM Session Manager for admin access (no public SSH).

12) Cost controls (especially for dev)

 Use one NAT Gateway (single-AZ) for dev; per-AZ in prod.

 Small EC2/RDS sizes for dev; enable scale-to-zero where possible (e.g., desired=0 if app allows).

 Shorter backup retention in dev; snapshots off when safe.

 Consider terraform destroy on dev when not in use.

13) Quality gates & CI

 Add .gitignore (ignore .terraform/, *.tfstate*).

 Add pre-commit hooks: terraform fmt, terraform validate, tflint.

 (Optional) GitHub Actions pipeline to run fmt/validate/plan on PRs.

14) Cleanup & lifecycle

 Document how to bootstrap (README).

 Document how to rotate DB password / secrets.

 Document how to rollback (AMIs, LT versions, ASG rollbacks).

 terraform destroy for dev when done.