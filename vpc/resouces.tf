#----------VPC-----------#

resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "terraform_vpc"
  }
}

#----------IGW------------#

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  tags = {
    Name = "terraform_igw"
  }
}

#-----------NAT--------------#

resource "aws_nat_gateway" "terraform_natgw" {
  allocation_id = "${aws_eip.terraform_eip.id}"
  subnet_id     = "${aws_subnet.terraform-subnet-private-1.id}"
  depends_on = ["aws_internet_gateway.terraform_igw"]

  tags = {
    name = "terraform_natgw"
  }
}

#------------EIP---------------#

resource "aws_eip" "terraform_eip" {
  vpc      = true
}

#-----------Route------------#
#-----------Public-Route-----#

resource "aws_route_table" "terraform_public_rt" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.terraform_igw.id}"
  }
  tags = {
    Name = "terraform_public_rt"
  }
}

#-----------Route------------#
#-----------Private-Route-----#

resource "aws_route_table" "terraform_private_rt" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.terraform_natgw.id}"
  }
  tags = {
    Name = "terraform_private_rt"
  }
}


#-----------Public-Route-Table-Association----#

resource "aws_route_table_association" "terraform_public_rt_1" {
  subnet_id      = "${aws_subnet.terraform-subnet-public-1.id}"
  route_table_id = "${aws_route_table.terraform_public_rt.id}"
}

resource "aws_route_table_association" "terraform_public_rt_2" {
  subnet_id      = "${aws_subnet.terraform-subnet-public-2.id}"
  route_table_id = "${aws_route_table.terraform_public_rt.id}"
}

#-----------Subnet-public-1--------#
resource "aws_subnet" "terraform-subnet-public-1" {
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "10.0.1.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "subnet-public-1"
  }
}

#-----------Subnet-public-2--------#
resource "aws_subnet" "terraform-subnet-public-2" {
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "10.0.2.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "subnet-public-2"
  }
}


#-----------Subnet-private-1--------#
resource "aws_subnet" "terraform-subnet-private-1" {
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "10.0.3.0/26"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "subnet-private-1"
  }
}

#-----------Subnet-private-2--------#
resource "aws_subnet" "terraform-subnet-private-2" {
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "10.0.4.0/26"
  map_public_ip_on_launch = "false"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "subnet-private-4"
  }
}

