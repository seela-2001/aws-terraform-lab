output "s3_bucket_id" {
  description = "ID of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.terraform_state_01.id
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id_1" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet_1.id
}

output "public_subnet_id_2" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet_2.id
}

output "private_subnet_id_1" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet_1.id
}

output "private_subnet_id_2" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet_2.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "eip1" {
  description = "Elastic IP for NAT Gateway 1"
  value       = aws_eip.nat_eip_1.id
}

output "eip2" {
  description = "Elastic IP for NAT Gateway 2"
  value       = aws_eip.nat_eip_2.id
}
