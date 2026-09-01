terraform {
    #s3 bucket and dynamodb created on aws console
    backend "s3" {
        bucket = ""
        key = "TerraformProjectTutorial/variablesAndOutputs/web-app/terraform.tfstate"
        region = "ap-southeast-1"
        dynamodb_table = " "
        encrypt = "true"
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~>6.0"
        }
    }
}

provider "aws" {
    region = var.region
}

resource "aws_instance" "instance_1" {
  ami                         = "ami-0532913178263be11"
  instance_type               = "t3.micro"
  key_name                    = "molina-key"
  vpc_security_group_ids      = [aws_security_group.instances.id]
  user_data                   = <<-EOF
            #!/bin/bash
            echo "Hello, World 1" > /home/ubuntu/index.html

            cat <<'UNIT' > /etc/systemd/system/webapp.service
            [Unit]
            Description=Simple Python Web Server
            After=network.target

            [Service]
            Type=simple
            User=ubuntu
            WorkingDirectory=/home/ubuntu
            ExecStart=/usr/bin/python3 -m http.server 8080
            Restart=always
            RestartSec=5

            [Install]
            WantedBy=multi-user.target
            UNIT

            systemctl daemon-reload
            systemctl enable webapp.service
            systemctl start webapp.service
            EOF
}

resource "aws_instance" "instance_2" {
  ami                         = "ami-0532913178263be11"
  instance_type               = "t3.micro"
  key_name                    = "molina-key"
  vpc_security_group_ids      = [aws_security_group.instances.id]
  user_data                   = <<-EOF
            #!/bin/bash
            echo "Hello, World 2" > /home/ubuntu/index.html

            cat <<'UNIT' > /etc/systemd/system/webapp.service
            [Unit]
            Description=Simple Python Web Server
            After=network.target

            [Service]
            Type=simple
            User=ubuntu
            WorkingDirectory=/home/ubuntu
            ExecStart=/usr/bin/python3 -m http.server 8080
            Restart=always
            RestartSec=5

            [Install]
            WantedBy=multi-user.target
            UNIT

            systemctl daemon-reload
            systemctl enable webapp.service
            systemctl start webapp.service
            EOF
}

resource "aws_s3_bucket" "bucket" {
    bucket_prefix = var.bucket_prefix
    force_destroy = true
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_crypto_conf" {
    bucket = aws_s3_bucket.bucket.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

data "aws_vpc" "default_vpc" {
    default = true
}

data "aws_subnet_ids" "default_subnet" {
    vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group_rule" "instances" {
    name = "instance-security-group"
}

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
            message_body = "404:response not found"
            status_code = 404
        }
    }
}

resource "aws_lb_target_group" "instances" {
    name = "molina-tagert-group"
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
            value = ["*"]
        }
    }
}

resource "aws_security_group_rule" "allow_alb_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_all_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_lb" "load_balancer" {
    name = "web-app-lb"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default_subnet.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_route53_zone" "primary" {
    name = var.domain
}

resource "aws_route53_record" "root" {
    zone_id = aws_route53_zone.primary.zone_id
    name = var.domain
    type = "A"

    alias {
        name = aws_lb.load_balancer.dns_name
        zone_id = aws_lb.load_balancer.zone_id
        evaluate_target_health = true
    }
}

resource "aws_db_instance" "db_instance" {
    allocated_storage = 20
    storage_type = "standard"
    engine = "postgres"
    engine_version = "12.5"
    instance_class = "db.t3.micro"
    name = var.db_name
    username = var.db_user
    password = var.db_password
    skip_final_snapshot = true
}