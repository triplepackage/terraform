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

variable "instanceTenancy" {
  default = "default"
}

variable "dnsSupport" {
  default = true
}

variable "dnsHostNames" {
  default = true
}

variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}

variable "subnetCIDRblock" {
  default = "10.0.1.0/24"
}

variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}

variable "ingressCIDRblock" {
  type = "list"
  default = [ "0.0.0.0/0" ]
}

variable "mapPublicIP" {
  default = true
}
