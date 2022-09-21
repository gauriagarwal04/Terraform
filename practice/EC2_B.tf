# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 3.72"
    
#     }
#   }
#    backend "remote" {
#     organization = "Gauri"

#     workspaces {
#       name = "Terraform"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

resource "aws_vpc" "vpc-B" {   
    cidr_block="${var.vpc-cidr[1]}"
    instance_tenancy="default"
    # Enabling automatic hostname assigning
    enable_dns_hostnames = true
    tags={
        Name="VPC B"
    }
}

resource "aws_subnet" "default_az1_B" {
    vpc_id=aws_vpc.vpc-B.id
    cidr_block="${var.Public_Subnet_1[1]}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags      = {
        Name    = "VPC B - AZ1"
    }
}

resource "aws_subnet" "default_az2_B" {
    vpc_id=aws_vpc.vpc-B.id
    cidr_block="${var.Public_Subnet_2[1]}"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
    tags      = {
        Name    = "VPC B - AZ2"
    }
}

resource aws_internet_gateway "internet_gw_B" {
    vpc_id = aws_vpc.vpc-B.id
    tags      = {
        Name    = "VPC B - IGW"
    }

}

resource "aws_route_table" "public-route-table_B" {
    vpc_id       = aws_vpc.vpc-B.id
    
    route {
        cidr_block="0.0.0.0/0"
        gateway_id=aws_internet_gateway.internet_gw_B.id

    }

    route {
      cidr_block = aws_vpc.vpc.cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
    }
    tags      = {
        Name    = "VPC B Route Table"
    }
}

resource "aws_route_table_association" "subnet1-rta-table_B" {
  subnet_id = aws_subnet.default_az1_B.id
  route_table_id = aws_route_table.public-route-table_B.id
}

resource "aws_route_table_association" "subnet2-rta-table_B" {
  subnet_id = aws_subnet.default_az2_B.id
  route_table_id = aws_route_table.public-route-table_B.id
}

#create aws security group
resource "aws_security_group" "webserver-security-group_B"{
  name = "sec_gr-using-terraform_B"
  vpc_id      = aws_vpc.vpc-B.id

  #Incoming traffic
  ingress {
    description      = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="ICMP rule"
    from_port = -1
    to_port = -1
    protocol = "icmp"
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

resource "aws_instance" "ec2_private_B" {
  ami = "ami-08c40ec9ead489470"
  instance_type = var.instance_type
  associate_public_ip_address=true
  subnet_id = aws_subnet.default_az1_B.id
  security_groups = ["${aws_security_group.webserver-security-group_B.id}"]
  tags = {
    "Name" = "EC2-Private-Instance-B"
  }
  
#user_data                   = "${data.template_file.provision.rendered}"
#iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
lifecycle {
create_before_destroy = true
}
  
}