# ALB Security group
# This is the group you need to edit if you want to restrict access to your application
resource "aws_security_group" "load_balancer" {
  name        = "tf-ecs-alb"
  description = "Controls access to the ALB"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ALB Security Group"
  }
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "Allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "80"
    to_port         = "80"
    security_groups = ["${aws_security_group.load_balancer.id}"]
  }

  ingress {
    protocol        = "tcp"
    from_port       = "8080"
    to_port         = "8080"
    security_groups = ["${aws_security_group.load_balancer.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "ECS Cluster Security Group"
  }
}

### ALB

resource "aws_alb" "main" {
  name            = "tf-ecs-rental"
  subnets         = ["${aws_subnet.public_subnet.*.id}"]
  security_groups = ["${aws_security_group.load_balancer.id}"]
}

resource "aws_alb_target_group" "rest_service" {
  name        = "tf-ecs-rental"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.default.id}"
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "rest_service" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.rest_service.id}"
    type             = "forward"
  }
}
