ec2_instance_type = "t2.micro"
instance_name = "my_instance_name"
subnet_prefix = [{ cidr_block = "10.0.1.0/24", name = "prod_subnet" }, { cidr_block = "10.0.2.0/24", name = "dev_subnet" }]
vpc_cidr_block = "10.0.0.0/16"