resource "aws_db_instance" "rental-mysql" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "rental"
  username             = "root"
  password             = "${var.mysql_password}"
  parameter_group_name = "default.mysql5.7"
  port                     = 3306
  publicly_accessible      = true
  skip_final_snapshot = true
  vpc_security_group_ids   = ["${aws_security_group.rental-mysql.id}"]
}

variable "rds_vpc_id" {
  default = "vpc-c75340a3"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "rds_public_subnets" {
  default = "vpc-c75340a3"
  description = "The public subnets of our RDS VPC rds-vpc."
}
