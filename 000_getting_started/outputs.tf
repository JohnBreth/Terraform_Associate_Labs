#Get specific data output after creation/modification, https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#attributes-reference
output "public_ip" {
  value = aws_instance.cyberinsight_server.public_ip
}