#Create resource
resource "aws_instance" "cyberinsight_server" {
  ami           = "ami-0b5eea76982371e91"
  instance_type = var.instance_type

  tags = {
    Name = "${local.project_name}-Server"
  }
}

#Use modules to configure a bunch of resources at one time. https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
/*module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "CyberInsight-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
*/

