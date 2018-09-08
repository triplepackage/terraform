resource "aws_db_instance" "rental-mysql" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "root"
  password             = "XXXXXX"
  parameter_group_name = "default.mysql5.7"
  port                     = 3306
  publicly_accessible      = true
}

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

variable "rds_vpc_id" {
  default = "vpc-c75340a3"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "rds_public_subnets" {
  default = "vpc-c75340a3"
  description = "The public subnets of our RDS VPC rds-vpc."
}
