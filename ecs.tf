data "template_file" "task_definition" {
 template = "${file("./task-definition.json")}"

 vars {
   mysql_host = "${aws_db_instance.rental-mysql.address}"
   hostname   = "jdbc:mysql://${aws_db_instance.rental-mysql.address}:3306/rental?useSSL=false"
   mysql_password = "${var.mysql_password}"
 }
}

resource "aws_ecs_cluster" "main" {
  name = "halifax"
}

resource "aws_ecs_task_definition" "app" {
  family                    = "rental-app"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  execution_role_arn        = "arn:aws:iam::002609254882:role/ecsTaskExecutionRole"
  cpu                       = "1024"
  memory                    = "2048"
  container_definitions     = "${data.template_file.task_definition.rendered}"

  depends_on = ["aws_internet_gateway.default", "aws_db_instance.rental-mysql"]
}

resource "aws_ecs_service" "main" {
  name            = "tf-ecs-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.public_subnet.*.id}"]
    assign_public_ip = "true"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.rest_service.id}"
    container_name   = "rental-services-api-jpa-stage"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.rest_service"
  ]
}
