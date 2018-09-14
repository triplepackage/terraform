resource "aws_db_instance" "rental-mysql" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "rental"
  username             = "root"
  password             = "${var.mysql_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds-subnet.name}"
  parameter_group_name = "default.mysql5.7"
  port                     = 3306
  publicly_accessible      = true
  skip_final_snapshot = true
  vpc_security_group_ids   = ["${aws_security_group.rental-mysql.id}"]

  tags{
    Name = "RDS Instance"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
    name = "rds-subnet"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
}
