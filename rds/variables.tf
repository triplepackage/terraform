variable "mysql_password" {}

variable "aws_region" {}
variable "aws_creds" {}
variable "aws_profile" {}

variable "availability_zone_main" {
  default = "us-east-1a"
}

variable "availability_zone_alternate" {
  default = "us-east-1b"
}

variable "instance_tenancy" {
  default = "default"
}

variable "dns_support" {
  default = true
}

variable "dns_host_names" {
  default = true
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "ingress_cidr_block" {
  type = "list"
  default = [ "0.0.0.0/0" ]
}

variable "map_public_ip" {
  default = true
}
