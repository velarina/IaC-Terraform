resource "aws_instance" "instance" {
  ami                    = "ami-0532913178263be11"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instances.id]
  user_data              = <<-EOF
            #!/bin/bash
            echo "Hello, World" > /home/ubuntu/index.html

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

resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

output "instance_ip_address" {
  value = aws_instance.instance.public_ip
}