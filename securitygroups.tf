resource "aws_security_group" "rental-mysql" {
  description = "Rental Database Security Group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidr_block}"
    security_groups = ["${aws_security_group.load_balancer.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "Rental Database Security Group"
  }
}
