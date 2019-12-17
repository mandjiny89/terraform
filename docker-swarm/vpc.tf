#----------VPC-----------#

resource "aws_vpc" "docker-vpc" {
  cidr_block           = "192.168.0.0/24"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "docker-vpc"
  }
}

#----------IGW------------#

resource "aws_internet_gateway" "docker_IGW" {
  vpc_id = "${aws_vpc.docker-vpc.id}"

  tags = {
    Name = "docker_IGW"
  }
}

#-----------Route------------#
#-----------Public-Route-----#

resource "aws_route_table" "docker_PUBLIC_RT" {
  vpc_id = "${aws_vpc.docker-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.docker_IGW.id}"
  }
  tags = {
    Name = "docker_PUBLIC_RT"
  }
}

#-----------Public-RT-Subnet-Association----#

resource "aws_route_table_association" "docker_PUBLIC_RT_ASS" {
  subnet_id      = "${aws_subnet.docker_SUBNET_PUBLIC_1b.id}"
  route_table_id = "${aws_route_table.docker_PUBLIC_RT.id}"
}

#-----------Subnet-public-1--------#
resource "aws_subnet" "docker_SUBNET_PUBLIC_1b" {
  vpc_id     = "${aws_vpc.docker-vpc.id}"
  cidr_block = "192.168.0.0/26"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "docker-subnet-public-1b"
  }
}

#---------------Security_Group-----------#

resource "aws_security_group" "docker_SG" {
  name        = "Linux_SSH"
  description = "Allowing all IP to port 22"
  vpc_id      = "${aws_vpc.docker-vpc.id}"

  ingress {
    # SSH (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # SSH (change to whatever ports you need)
    from_port   = 2337
    to_port     = 2337
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
    Name = "Linux_SSH"
 }
}


