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
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}
