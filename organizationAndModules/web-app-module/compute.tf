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