output "instance_ip_addr" {
  value = "${aws_instance.SI_SERVER.public_ip}"
}
