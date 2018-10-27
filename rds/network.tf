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

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 8, var.az_count + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.default.id}"
  map_public_ip_on_launch = "${var.map_public_ip}"
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.default.id}"
  tags {
    Name = "Private Subnet"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.public_subnet.*.id}", "${aws_subnet.private_subnet.*.id}"]
    depends_on = ["aws_subnet.public_subnet", "aws_subnet.private_subnet"]
    tags = {
      Name = "RDS DB Subnet Group"
    }
}

resource "aws_network_acl" "default" {
  count         = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"
  subnet_ids = ["${element(aws_subnet.public_subnet.*.id, count.index)}"]

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
    Name = "Public ACL"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Default Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Public Route Table"
  }
}

resource "aws_route" "internet_access" {
  route_table_id        = "${aws_route_table.public.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_eip" "gateway" {
  count         = "${var.az_count}"
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "gateway" {
  count         = "${var.az_count}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  allocation_id = "${element(aws_eip.gateway.*.id, count.index)}"
}

# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gateway.*.id, count.index)}"
  }
  tags {
    Name = "Private VPC Route Table"
  }
}

resource "aws_route_table_association" "route_association_private" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "route_association_public" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}
