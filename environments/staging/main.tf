terraform {

    cloud { 
    organization = "MARY" 

    workspaces { 
      name = "HUG_IB_TF" 
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