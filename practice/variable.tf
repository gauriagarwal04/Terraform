variable "vpc-cidr" {
    default=["10.0.0.0/16","10.1.0.0/16","10.2.0.0/16"]
    type=list(string)
    description = "VPC CIDR block"
}

# variable "Public_Subnet_1" {
# default = "10.0.0.0/24"
# description = "Public_Subnet_1"
# type = string
# }

variable "Public_Subnet_1" {
    default=["10.0.0.0/24","10.1.0.0/24","10.2.0.0/24"]
    type=list(string)
    description = "Available zone 1 subnet"
}

variable "Public_Subnet_2" {
 
    default=["10.0.1.0/24","10.1.1.0/24","10.2.1.0/24"]
    type=list(string)
    description = "Available zone 2 subnet" 
}

variable "instance_type" {
  default = "t2.micro"
  type=string
}