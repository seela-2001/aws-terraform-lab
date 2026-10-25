output "s3_bucket_id" {
  description = "ID of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.terraform_state_01.id
}
