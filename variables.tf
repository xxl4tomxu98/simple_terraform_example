variable "instance_name" {
    description = "Value of the Name tag for the EC2 instance"
    type = string
    default = "my_instance"
}

variable "ec2_instance_type" {  
    description = "Type of AWS EC2 instance to launch"  
    type = string
    default = "t2.micro"
}

variable "vpc_name" {
    description = "Value of the Name tag for the VPC"
    type = string
    default = "my_vpc"
}

variable "subnet_prefix" {
    description = "cidr block and name tag for the subnets"
    type = list
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "igw_name" {
    description = "Value of the Name tag for the igw in VPC"
    type = string
    default = "my_igw"
}

variable "ec2_ami" {
    description = "Value of the ami id for the EC2 instance"
    type = string
    default = "ami-04b70fa74e45c3917"
}

variable "availability_zone" {
    description = "Availability zone for the EC2 instance"
    type = string
    default = "us-east-1a"  
}

variable "route_table_name" {
    description = "Value of the Name tag for the route table"
    type = string
    default = "prod_route_table"
}

variable "aws_key_name" {
    description = "Name of the AWS Key Pair to use for the EC2 instance"
    type = string
    default = "aws_key"
}