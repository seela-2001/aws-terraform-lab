variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "terraform-lab"
}

variable "vpc_tag" {
  description = "The tag to identify the VPC"
  type        = string
  default     = "main-vpc"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t3.micro"
}