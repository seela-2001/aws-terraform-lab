resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    description = "Allow HTTP traffic from the internet"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    description = "Allow all outbound traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "${var.project}-frontend-sg"
  description = "Security group for frontend instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP traffic from ALB only"
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_sg.id]
  }

  tags = {
    Name = "${var.project}-frontend-sg"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "${var.project}-backend-sg"
  description = "Security group for backend instances"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "Allow all outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-backend-sg"
  }
}