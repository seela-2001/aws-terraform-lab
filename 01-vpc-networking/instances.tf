data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "backend_instance_1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y python3

    mkdir -p /opt/backend
    cat > /opt/backend/server.py <<'PY'
    from http.server import BaseHTTPRequestHandler, HTTPServer

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            body = b"Backend instance 1 is healthy\n"
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
    PY

    cat > /etc/systemd/system/backend.service <<'SERVICE'
    [Unit]
    Description=Backend HTTP service
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /opt/backend/server.py
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now backend
  EOF

  tags = {
    Name = "${var.project}-backend-1"
    Tier = "backend"
  }
}

resource "aws_instance" "backend_instance_2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y python3

    mkdir -p /opt/backend
    cat > /opt/backend/server.py <<'PY'
    from http.server import BaseHTTPRequestHandler, HTTPServer

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            body = b"Backend instance 2 is healthy\n"
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

    HTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
    PY

    cat > /etc/systemd/system/backend.service <<'SERVICE'
    [Unit]
    Description=Backend HTTP service
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /opt/backend/server.py
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now backend
  EOF

  tags = {
    Name = "${var.project}-backend-2"
    Tier = "backend"
  }
}

resource "aws_instance" "frontend_instance_1" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y nginx

    cat > /etc/nginx/sites-available/default <<'NGINX'
    upstream backend_servers {
        server ${aws_instance.backend_instance_1.private_ip}:8000;
        server ${aws_instance.backend_instance_2.private_ip}:8000;
    }

    server {
        listen 80 default_server;
        server_name _;

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
    NGINX

    nginx -t
    systemctl enable --now nginx
    systemctl restart nginx
  EOF

  depends_on = [
    aws_instance.backend_instance_1,
    aws_instance.backend_instance_2
  ]

  tags = {
    Name = "${var.project}-frontend-1"
    Tier = "frontend"
  }
}

resource "aws_instance" "frontend_instance_2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y nginx

    cat > /etc/nginx/sites-available/default <<'NGINX'
    upstream backend_servers {
        server ${aws_instance.backend_instance_1.private_ip}:8000;
        server ${aws_instance.backend_instance_2.private_ip}:8000;
    }

    server {
        listen 80 default_server;
        server_name _;

        location / {
            proxy_pass http://backend_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
    NGINX

    nginx -t
    systemctl enable --now nginx
    systemctl restart nginx
  EOF

  depends_on = [
    aws_instance.backend_instance_1,
    aws_instance.backend_instance_2
  ]

  tags = {
    Name = "${var.project}-frontend-2"
    Tier = "frontend"
  }
}
