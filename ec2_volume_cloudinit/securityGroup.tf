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

