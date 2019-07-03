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

variable "map_public_ip_on_launch" {
  default = true
}

variable "dns_host_names" {
  default = true
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_rds_private_cidr_block" {
  default = "10.0.4.0/24"
}

variable "subnet_rds_public_cidr_block" {
  default = "10.0.5.0/24"
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

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}
