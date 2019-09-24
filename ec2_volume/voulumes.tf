resource "aws_ebs_volume" "SI_VOLUME" {
  availability_zone = "eu-west-1b"
  size              = 10
  type              = "standard"

  tags = {
    Name = "Additional Stroage"
  }
}

resource "aws_volume_attachment" "SI_VOLUME_EBS_ATT" {
  device_name = "/dev/sdb"
  volume_id   = "${aws_ebs_volume.SI_VOLUME.id}"
  instance_id = "${aws_instance.SI_SERVER.id}"
}
