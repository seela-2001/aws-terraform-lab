resource "aws_s3_bucket" "terraform_state_01" {
  bucket = "terraform-state-01-vpc-networking"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_01_versioning" {
  bucket = aws_s3_bucket.terraform_state_01.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_01_encryption" {
  bucket = aws_s3_bucket.terraform_state_01.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_01_public_access_block" {
  bucket                  = aws_s3_bucket.terraform_state_01.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
