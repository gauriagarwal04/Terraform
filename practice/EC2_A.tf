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

resource "aws_vpc" "vpc" {   
    cidr_block="${var.vpc-cidr[0]}"
    instance_tenancy="default"
    # Enabling automatic hostname assigning
    enable_dns_hostnames = true
    tags={
        Name="VPC A"
    }
}

resource "aws_subnet" "default_az1" {
    vpc_id=aws_vpc.vpc.id
    cidr_block="${var.Public_Subnet_1[0]}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags      = {
        Name    = "VPC A - AZ1"
    }
}

resource "aws_subnet" "default_az2" {
    vpc_id=aws_vpc.vpc.id
    cidr_block="${var.Public_Subnet_2[0]}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags      = {
        Name    = "VPC A - AZ2"
    }
}

resource aws_internet_gateway "internet_gw" {
    vpc_id = aws_vpc.vpc.id
    tags      = {
        Name    = "VPC A - IGW"
    }

}

resource "aws_route_table" "public-route-table" {
    vpc_id       = aws_vpc.vpc.id
    
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.internet_gw.id

    }

    route {
      cidr_block = aws_vpc.vpc-B.cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
    }

    route {
      cidr_block = aws_vpc.vpc_c.cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.owner_A-C.id
    }

    tags      = {
        Name    = "VPC A Route Table"
    }
}

resource "aws_route_table_association" "subnet1-rta-table" {
  subnet_id = aws_subnet.default_az1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "subnet2-rta-table" {
  subnet_id = aws_subnet.default_az2.id
  route_table_id = aws_route_table.public-route-table.id
}

#create aws security group
resource "aws_security_group" "webserver-security-group"{
  name = "sec_gr-using-terraform"
  vpc_id      = aws_vpc.vpc.id

  #Incoming traffic
  ingress {
    description      = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description      = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  #Outgoing traffic
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "ec2_private" {
  ami = "ami-068257025f72f470d"
  instance_type = var.instance_type
  subnet_id = aws_subnet.default_az1.id
  security_groups = ["${aws_security_group.webserver-security-group.id}"]
  tags = {
    "Name" = "EC2-Private-Instance-A"
  }
  associate_public_ip_address = false
#user_data                   = "${data.template_file.provision.rendered}"
#iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
lifecycle {
create_before_destroy = true
}
  
}

