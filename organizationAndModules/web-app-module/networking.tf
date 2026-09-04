#virtual private group
data "aws_vpc" "default_vpc" {
    default = true
}

#subnet
data "aws_subnets" "default_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

#security group for both the instances
resource "aws_security_group" "instances" {
  name = "${var.app_name}-${var.environment_name}-instance-security-group"
}

#the security group rule for allowing HTTP inbound traffic access
resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port = 80

  protocol = "HTTP"

  #by default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code = "404"
    }
  }
}

#load balancer target group
resource "aws_lb_target_group" "instances" {
    name = "${var.app_name}-${var.environment_name}-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default_vpc.id

    health_check {
      path = "/"
      protocol = "HTTP"
      matcher = "200"
      interval = 15
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "instance_1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id = aws_instance.instance_1.id
  port = 8080
}

resource "aws_lb_target_group_attachment" "instance_2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id = aws_instance.instance_2.id
  port = 8080
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = (["*"])
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}

#application load balancer
resource "aws_security_group" "alb" {
  name = "${var.app_name}-${var.environment_name}-alb-security-group"
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
    type = "ingress"
    security_group_id = aws_security_group.alb.id

    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id

  from_port = 0
  to_port = 0
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
    name = "${var.app_name}-${var.environment_name}-web-app-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnets.default_subnet.ids
    security_groups = [aws_security_group.alb.id]
}