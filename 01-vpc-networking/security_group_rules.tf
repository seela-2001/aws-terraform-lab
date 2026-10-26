resource "aws_vpc_security_group_egress_rule" "frontend_to_backend" {
  security_group_id            = aws_security_group.frontend_sg.id
  referenced_security_group_id = aws_security_group.backend_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
  description                  = "Allow HTTP traffic from frontend instances to backend instances"
}


resource "aws_vpc_security_group_egress_rule" "frontend_egress" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic through NAT"
}


resource "aws_vpc_security_group_ingress_rule" "backend_from_frontend" {
  security_group_id            = aws_security_group.backend_sg.id
  referenced_security_group_id = aws_security_group.frontend_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 8000
  to_port                      = 8000
  description                  = "Allow HTTP traffic from frontend instances to backend instances"
}