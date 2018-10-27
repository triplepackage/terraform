#
# Module: tf_aws_rds
#

# Output the ID of the RDS instance
output "rds_instance_id" {
  value = "${aws_db_instance.rental-mysql.id}"
}

# Output the address (aka hostname) of the RDS instance
output "rds_instance_address" {
  value = "${aws_db_instance.rental-mysql.address}"
}

# Output endpoint (hostname:port) of the RDS instance
output "rds_instance_endpoint" {
  value = "${aws_db_instance.rental-mysql.endpoint}"
}

# Output the ID of the Subnet Group
output "subnet_group_id" {
  value = "${aws_db_subnet_group.rds-subnet.id}"
}

# Output DB security group ID
output "security_group_id" {
  value = "${aws_security_group.rental-mysql.id}"
}

#Output contents of ECS task definition
output "aws_ecs_task_definition"{
  value = "${aws_ecs_task_definition.app.container_definitions}"
}

#Output public DNS of load balancer
output "alb.dns_name"{
  value = "${aws_alb.main.dns_name}"
}

#Output public Rental Rest Service URL
output "rental_service_url"{
  value = "http://${aws_alb.main.dns_name}:8080/swagger-ui.html"
}
