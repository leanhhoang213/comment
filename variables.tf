
variable "profile" {
  default = "aws_lab"
}

variable "vpc_cidr_block" {
  default = "10.128.0.0/20"
}

variable "private_subnet_cidr" {
  default = [
    "10.128.0.0/24",
    "10.128.1.0/24",
    "10.128.2.0/24"
  ]
}

variable "public_subnet_cidr" {
  default = [
    "10.128.4.0/24",
    "10.128.5.0/24",
    "10.128.6.0/24"
  ]
}

variable "az" {
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

variable "tg_att" {
  default = "10.128.1.198"
}
