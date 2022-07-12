terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "energize-airflow" {
  ami           = "ami-002ff2c881c910aa8"
  instance_type = "t2.large"
  key_name      = "tope"
  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    volume_size = 30
  }

  tags = {
    Name = "airflow-instance"
  }
}

resource "aws_s3_bucket" "energize-data-lake" {
  bucket = "energize-data-lake"
}

resource "aws_key_pair" "local-key" {
  key_name   = "tope"
  public_key = var.public_key
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

