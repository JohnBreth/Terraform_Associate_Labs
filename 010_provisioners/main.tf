#Using AWS as a Provider, https://registry.terraform.io/providers/hashicorp/aws/0.1.0
terraform {
  #If no cloud section is used, this defaults to local. Organization must be created in terraform cloud.https://developer.hashicorp.com/terraform/tutorials/state/cloud-migrate
  cloud {
    organization = "CyberInsightLab"

    workspaces {
      name = "provisioners"
    }
  }

  #Terraform AWS modules
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.49.0"
    }
  }
}

#Set AWS as provider
provider "aws" {
  region  = "us-east-1"
}

#Test server resource
resource "aws_instance" "cyberinsight_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"

  tags = {
    Name = "CyberInsight-Server"
  }
}

#Get specific data output after creation/modification, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference
output "public_ip" {
  value = aws_instance.cyberinsight_server.public_ip
}