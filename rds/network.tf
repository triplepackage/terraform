provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_creds}"
  profile                 = "${var.aws_profile}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}"
  enable_dns_support   = "${var.dnsSupport}"
  enable_dns_hostnames = "${var.dnsHostNames}"
tags {
    Name = "Default VPC"
  }
}

resource "aws_subnet" "main-public-1" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availability_zone_main}"
  tags = {
    Name = "Default VPC Public Subnet"
  }
}

resource "aws_subnet" "main-public-2" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "${var.availability_zone_alternate}"
    tags {
        Name = "Alternate VPC Public Subnet"
    }
}

resource "aws_security_group" "default" {
  vpc_id       = "${aws_vpc.default.id}"
  name         = "Default VPC Security Group"
  description  = "Default VPC Security Group"
  ingress {
  cidr_blocks = "${var.ingressCIDRblock}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
tags = {
        Name = "Default VPC Security Group"
  }
}
resource "aws_network_acl" "default" {
  vpc_id = "${aws_vpc.default.id}"
  subnet_ids = [ "${aws_subnet.main-public-1.id}" ]
# allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 22
    to_port    = 22
  }

# allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 1024
    to_port    = 65535
  }

# allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port  = 1024
    to_port    = 65535
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

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Default VPC Route Table"
  }
}

resource "aws_route" "default" {
  route_table_id        = "${aws_route_table.default.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "default" {
    subnet_id      = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.default.id}"
}
