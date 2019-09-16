provider "aws" {
  version    = "~> 2.0"
  region     = "${var.AWS_REGION}"
  access_key = "${var.AWS_ACCESS_KEY_ID}"
  secret_key = "${var.AWS_SECRET_ACCESS_ID_KEY}"
}
