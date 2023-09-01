provider "aws" {
  region = "ap-southeast-1"
}

resource "tls_private_key" "master-key-gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "master-key-pair" {
  key_name   = "keypair"
  public_key = tls_private_key.master-key-gen.public_key_openssh
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-0df7a207adb9748c7"
  instance_type = "t3a.small"
  key_name      = aws_key_pair.master-key-pair.key_name  
  tags = {
    Name = "demo"
  }
}

output "pem_file_for_ssh" {
  value = tls_private_key.master-key-gen.private_key_pem
  sensitive = true
}

output "ec2" {
  value = aws_instance.demo_ec2.public_ip
}
