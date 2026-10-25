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