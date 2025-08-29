terraform {
    cloud { 
    organization = "MARY" 

    workspaces { 
      name = "aws_multi_tier_environment" 
    } 
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.10.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

module "compute" {
  source = "../../modules/compute"
  vpc_id         = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids = module.networking.public_subnet_ids
  app_port       = 80
  desired_capacity = 2
  max_size       = 3
  min_size       = 1
  instance_type  = "t3.micro"
  tags           = {
    Environment = "development"
    Project     = "multi-tier-app"
  }
  
}

module "networking" {
  source = "../../modules/networking"
  vpc_cidr = var.vpc_cidr
  private_subnet_cidrs =var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

module "database" {
  source = "../../modules/database"
  vpc_id              = module.networking.vpc_id
  private_subnet_ids  = module.networking.private_subnet_ids
  db_engine           = var.db_engine
  engine_version      = var.engine_version
  instance_class      = var.instance_class
  allocated_storage   = var.allocated_storage
  multi_az            = false
  username            = var.username
  password            = var.password 
  backup_retention_period = 1
  deletion_protection     = false
  app_security_group_id   = module.compute.alb_security_group_id
}
