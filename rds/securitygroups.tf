resource "aws_security_group" "rental-mysql" {
  name = "rental-mysql"

  description = "RDS MySql servers (terraform-managed)"
  vpc_id = "${var.rds_vpc_id}"

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
}
