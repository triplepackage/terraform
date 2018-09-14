resource "aws_security_group" "rental-mysql" {
  description = "RDS MySql servers (terraform-managed)"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = "${var.ingressCIDRblock}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "${var.ingressCIDRblock}"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "Rental Database VPC Security Group"
  }
}
