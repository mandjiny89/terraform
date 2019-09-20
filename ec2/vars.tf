variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_ID_KEY" {}

# Below variable using a single string variable, we also have list, map and etc.
variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "public_key" {}

variable "region_ami" {
  type = "map"
default = {
    eu-west-1      = "ami-028188d9b49b32a80"
    eu-west-2      = "ami-04de2b60dd25fbb2e"
    eu-west-3      = "ami-0652eb0db9b20aeaf"
  }
}
