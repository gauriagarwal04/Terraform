terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    
    }
  }
   backend "remote" {
    organization = "Gauri"

    workspaces {
      name = "Terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}
