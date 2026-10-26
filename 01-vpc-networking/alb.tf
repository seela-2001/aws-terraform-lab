
resource "aws_lb" "frontend_alb" {
  name               = "${var.project}-frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "${var.project}-frontend-alb"
  }
}

resource "aws_lb_target_group" "frontend_tg" {
  name     = "${var.project}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.project}-frontend-tg"
  }
}

resource "aws_lb_target_group_attachment" "frontend_1" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = aws_instance.frontend_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "frontend_2" {
  target_group_arn = aws_lb_target_group.frontend_tg.arn
  target_id        = aws_instance.frontend_instance_2.id
  port             = 80
}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_tg.arn
  }
}

output "frontend_alb_dns_name" {
  description = "Public DNS name of the frontend ALB"
  value       = aws_lb.frontend_alb.dns_name
}
