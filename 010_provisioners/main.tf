#Using AWS as a Provider, https://registry.terraform.io/providers/hashicorp/aws/0.1.0
terraform {
  #If no cloud section is used, this defaults to local. Organization must be created in terraform cloud.https://developer.hashicorp.com/terraform/tutorials/state/cloud-migrate
  cloud {
    organization = "CyberInsightLab"

    workspaces {
      name = "provisioners"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}