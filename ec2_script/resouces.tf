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

#---------------Security_Group-----------#

resource "aws_security_group" "SI_SG" {
  name        = "Linux_SSH"
  description = "Allowing all IP to port 22"
  vpc_id      = "${aws_vpc.SI_VPC.id}"

  ingress {
    # SSH (change to whatever ports you need)
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
    Name = "Linux_SSH"
 }
}

#------------------------------------------------EC2_Provisioning-------------------------------#

#------------Key-Pair-----------#
resource "aws_key_pair" "SI_KEYPAIR" {
  key_name   = "SI_KEYPAIR"
  public_key = "${var.public_key}"
}

#------------Instance-Provisioning-------#

resource "aws_instance" "SI_SERVER" {
  ami           = "${var.region_ami["${var.AWS_REGION}"]}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1b"
  disable_api_termination = "false"
  key_name = "${aws_key_pair.SI_KEYPAIR.key_name}"
  vpc_security_group_ids = [aws_security_group.SI_SG.id]
  subnet_id = "${aws_subnet.SI_SUBNET_PUBLIC_1b.id}"
  
#-----------using file module you can copy to remote system--------------------#
  provisioner "file" {
    source = "script.sh"
    destination = "/home/ec2-user/script.sh"
  }
#---------------remote-exec will be used to execute something in the romote---------#
   
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/script.sh",
      "sudo /home/ec2-user/script.sh",
    ]
  }
#------------connection used to connect to the remote server to make activity----------#

    connection{
      host = "${aws_instance.SI_SERVER.public_ip}"
      user = "${var.instance_username}"
      type = "ssh"
      # to use private_key, you need to use file function to call the privatekey file
      private_key = file("${var.path_to_private_key}")
 } 
}


