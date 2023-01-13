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

#Setup main VPC with ID
data "aws_vpc" "main" {
  id = "vpc-073106e1fef1e09ce"
}

#Set SSH key
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBV0R1YyPXOKJpXal4rlI+nk8o/1Aze232DFBnzM1s1wGPshU6jGSS6jCMrn4sYRqjljfTVHRTxoT0v70Obr1pPnGUw8OM0rjY5QSeodfW6VW2Nvr2gx3BqSMQb3AUQdIIbdXtJiY1Ers5194fmb+Gtx2I9cpunXvRsMSqh1XkSA33Vi3qn/B4wNH715W94kJOcpoFInE7+XEd/WGv0GbbvGzE3X8Z54NCLC8ZsmGXEzHb68RZsS9XhPWcnPSWUWBa4rwaCPobLNcN8PVjdS8TnfKSlIaSJCKEiPUqm9TUzGtMNs5z5492mQMruQlpXxqHD+s9isNgUtmtO8G6lRMhUM5nJbkRL7xhzvl/k07GZmRlR3xYBYdXpV1YFsrEvkYEczxULSLSNEf7TycF6Bdgds/QgnQ/Top8CCz0yp8zyyQo7Z6FIHf3eKb2xLH3KqI7AXD9wrCekoo+hoPKYT3vafYwCNPRe/16ob+jTHDHqxgFhsB9JjuLVqC7eL+yFuM="
}

#Set up reference to user data file that will run some commands on resource
data "template_file" "user_data" {
	template = file("./userdata.yml")
}

#Security Group to allow only approved inbound access
resource "aws_security_group" "sg_cyberinsightserver" {
  name        = "sg_cyberinsightserver"
  description = "CyberInsight_Server Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
			prefix_list_ids  = []
			security_groups = []
			self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.10.10.10/32"]
      ipv6_cidr_blocks = []
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]

  egress = [
    {
			description = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]
}

#Test server resource, pull over SSH key, set security group, and pull and run user data file
resource "aws_instance" "cyberinsight_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
        key_name = "${aws_key_pair.deployer.key_name}"
        vpc_security_group_ids = [aws_security_group.sg_cyberinsightserver.id]
        user_data = data.template_file.user_data.rendered
  tags = {
    Name = "CyberInsight-Server"
  }
}

#Get specific data output after creation/modification, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference
output "public_ip" {
  value = aws_instance.cyberinsight_server.public_ip
}