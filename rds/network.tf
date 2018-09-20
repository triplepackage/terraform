provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_creds}"
  profile                 = "${var.aws_profile}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_host_names}"
  tags {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.subnet_cidr_block}"
  map_public_ip_on_launch = "${var.map_public_ip}"
  availability_zone       = "${var.availability_zone_main}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "VPC Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.availability_zone_alternate}"
    map_public_ip_on_launch = "true"
    tags {
        Name = "VPC Private Subnet"
    }
}

resource "aws_db_subnet_group" "rds-subnet" {
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.public_subnet.id}", "${aws_subnet.private_subnet.id}"]
    tags = {
      Name = "RDS DB Subnet Group"
    }
}

resource "aws_network_acl" "default" {
  vpc_id = "${aws_vpc.default.id}"
  subnet_ids = [ "${aws_subnet.public_subnet.id}" ]

  ingress {
      protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destination_cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destination_cidr_block}"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name = "Default VPC ACL"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Default VPC Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Public VPC Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Private VPC Route Table"
  }
}

resource "aws_route" "default" {
  route_table_id        = "${aws_route_table.public.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "route_association_1" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "route_association_2" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private.id}"
}
