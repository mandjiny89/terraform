#------------------------------------------------EC2_Provisioning-------------------------------#

#------------Key-Pair-----------#
resource "aws_key_pair" "docker_KEYPAIR" {
  key_name   = "docker_KEYPAIR"
  public_key = "${var.public_key}"
}

#------------Instance-Provisioning-------#

resource "aws_instance" "docker_master" {
  ami           = "${var.region_ami["${var.AWS_REGION}"]}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1b"
  disable_api_termination = "false"
  key_name = "${aws_key_pair.docker_KEYPAIR.key_name}"
  vpc_security_group_ids = [aws_security_group.docker_SG.id]
  subnet_id = "${aws_subnet.docker_SUBNET_PUBLIC_1b.id}"
  #depends_on = ["aws_vpc.docker_VPC.id"]
#  user_data = <<EOF
#            sudo yum update -y
#            sudo amazon-linux-extras install docker
#            sudo service docker start
#            sudo service docker enable
#            sudo usermod -a -G docker ec2-user
#            docker swarm init --advertise-addr="[${aws_instance.docker_master.public_ip}]":2377
# EOF
 tags = {
    Name = "docker_master"
  }
}

resource "aws_instance" "docker_worker" {
  ami           = "${var.region_ami["${var.AWS_REGION}"]}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1b"
  disable_api_termination = "false"
  key_name = "${aws_key_pair.docker_KEYPAIR.key_name}"
  vpc_security_group_ids = [aws_security_group.docker_SG.id]
  subnet_id = "${aws_subnet.docker_SUBNET_PUBLIC_1b.id}"
  #depends_on = ["aws_vpc.docker_VPC.id"]
  tags = {
    Name = "docker_worker"
  }
}

