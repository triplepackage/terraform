provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "${var.aws_creds}"
  profile                 = "${var.aws_profile}"
}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_host_names}"
  tags {
    Name = "Default VPC"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnet" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 8, var.az_count + count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.default.id}"
  map_public_ip_on_launch = "${var.map_public_ip}"
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = "${var.az_count}"
  cidr_block              = "${cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id                  = "${aws_vpc.default.id}"
  tags {
    Name = "Private Subnet"
  }
}

resource "aws_db_subnet_group" "rds-subnet" {
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.public_subnet.*.id}", "${aws_subnet.private_subnet.*.id}"]
    depends_on = ["aws_subnet.public_subnet", "aws_subnet.private_subnet"]
    tags = {
      Name = "RDS DB Subnet Group"
    }
}

resource "aws_network_acl" "default" {
  count         = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"
  subnet_ids = ["${element(aws_subnet.public_subnet.*.id, count.index)}"]

  ingress {
      protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destination_cidr_block}"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.destination_cidr_block}"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name = "Default VPC ACL"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Default VPC Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "Public VPC Route Table"
  }
}

resource "aws_route" "internet_access" {
  route_table_id        = "${aws_route_table.public.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_eip" "gateway" {
  count         = "${var.az_count}"
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "gateway" {
  count         = "${var.az_count}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  allocation_id = "${element(aws_eip.gateway.*.id, count.index)}"
}

# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gateway.*.id, count.index)}"
  }
  tags {
    Name = "Private VPC Route Table"
  }
}

resource "aws_route_table_association" "route_association_private" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "route_association_public" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
}

### Security

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

### ECS

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
  container_definitions = "${file("./task-def.json")}"
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
