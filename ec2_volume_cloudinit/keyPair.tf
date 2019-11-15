#------------Key-Pair-----------#
resource "aws_key_pair" "SI_KEYPAIR" {
  key_name   = "SI_KEYPAIR"
  public_key = "${var.public_key}"
}

