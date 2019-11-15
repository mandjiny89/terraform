
#------------Instance-Provisioning-------#

resource "aws_instance" "SI_SERVER" {
  ami           = "${var.region_ami["${var.AWS_REGION}"]}"
  instance_type = "t2.micro"
  availability_zone = "eu-west-1b"
  disable_api_termination = "false"
  key_name = "${aws_key_pair.SI_KEYPAIR.key_name}"
  vpc_security_group_ids = [aws_security_group.SI_SG.id]
  subnet_id = "${aws_subnet.SI_SUBNET_PUBLIC_1b.id}"
  user_data = data.template_cloudinit_config.cloudinit-example.rendered
  tags = {
    Name = "SI_SERVER"
  }
}
