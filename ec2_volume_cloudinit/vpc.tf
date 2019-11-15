#----------VPC-----------#

resource "aws_vpc" "SI_VPC" {
  cidr_block           = "192.168.0.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "SI_VPC"
  }
}

#----------IGW------------#

resource "aws_internet_gateway" "SI_IGW" {
  vpc_id = "${aws_vpc.SI_VPC.id}"

  tags = {
    Name = "SI_IGW"
  }
}

#-----------Route------------#
#-----------Public-Route-----#

resource "aws_route_table" "SI_PUBLIC_RT" {
  vpc_id = "${aws_vpc.SI_VPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.SI_IGW.id}"
  }
  tags = {
    Name = "SI_PUBLIC_RT"
  }
}

#-----------Public-RT-Subnet-Association----#

resource "aws_route_table_association" "SI_PUBLIC_RT_ASS" {
  subnet_id      = "${aws_subnet.SI_SUBNET_PUBLIC_1b.id}"
  route_table_id = "${aws_route_table.SI_PUBLIC_RT.id}"
}

#-----------Subnet-public-1--------#
resource "aws_subnet" "SI_SUBNET_PUBLIC_1b" {
  vpc_id     = "${aws_vpc.SI_VPC.id}"
  cidr_block = "192.168.0.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "SI-subnet-public-1b"
  }
}


