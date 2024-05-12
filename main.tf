
provider "aws" {
    #This is the default profile for local credential, if terraform cloud is not used
    #profile = "default"
    region = "us-east-1"    
}

# create vpc
resource "aws_vpc" "my_cloud_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = var.vpc_name
    }
}

# create internet gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.my_cloud_vpc.id
    tags = {
        Name = var.igw_name
    }
}

# create route table
resource "aws_route_table" "prod_route_table" {
    vpc_id = aws_vpc.my_cloud_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
        Name = var.route_table_name 
    }
}

# create subnet
resource "aws_subnet" "subnet1" {
    vpc_id     = aws_vpc.my_cloud_vpc.id   
    cidr_block = var.subnet_prefix[0].cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name = var.subnet_prefix[0].name
    }
}

resource "aws_subnet" "subnet2" {
    vpc_id     = aws_vpc.my_cloud_vpc.id
    cidr_block = var.subnet_prefix[1].cidr_block
    availability_zone = var.availability_zone
    tags = {
        Name = var.subnet_prefix[1].name
    }
}

# associate subnet with route table
resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.subnet1.id
    route_table_id = aws_route_table.prod_route_table.id
}

# create security group
resource "aws_security_group" "allow_web" {
    name = "allow_web_traffic"
    description = "Allow inbound web traffic"
    vpc_id      = aws_vpc.my_cloud_vpc.id
    ingress {
        description = "HTTPS from vpc"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP from vpc"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH from vpc"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "allow_web"
    }
}

# create network interface
resource "aws_network_interface" "web_server_nic" {
    subnet_id       = aws_subnet.subnet1.id
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id]   
}

# create elastic ip address
resource "aws_eip" "one" {
    domain = "vpc" 
    network_interface = aws_network_interface.web_server_nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [aws_internet_gateway.gw]
}

# create ubuntu ec2 instance
resource "aws_instance" "web_server_instance" {
    ami           = var.ec2_ami
    instance_type = var.ec2_instance_type
    availability_zone = var.availability_zone
    key_name = var.aws_key_name
    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web_server_nic.id
    }
    tags = {
        Name = var.instance_name
    }
    user_data = <<-EOF
                  #!/bin/bash -ex
                  sudo apt update -y
                  sudo apt install -y apache2
                  sudo systemctl enable apache2
                  sudo systemctl start apache2                
                  sudo bash -c 'echo "Hello! My First Web App" > /var/www/html/index.html'
                  EOF
}
