resource "aws_db_instance" "rental-mysql" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.small"
  name                 = "rental"
  username             = "root"
  password             = "${var.mysql_password}"
  db_subnet_group_name = "${aws_db_subnet_group.rds-subnet.name}"
  parameter_group_name = "default.mysql5.7"
  port                     = 3306
  publicly_accessible      = true
  skip_final_snapshot = true
  vpc_security_group_ids   = ["${aws_security_group.rental-mysql.id}", "${aws_security_group.ecs_tasks.id}"]

  depends_on = [
    "aws_db_subnet_group.rds-subnet"
  ]

  tags{
    Name = "RDS MySql Instance"
  }
}
