terraform {
  backend "s3" {
    bucket = "terraform-state-01-vpc-networking"
    key    = "terraform.tfstate"
    region = "eu-north-1"
  }
}
