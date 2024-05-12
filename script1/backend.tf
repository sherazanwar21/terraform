terraform {
  backend "s3" {
    bucket  = "sheraztf-state-bucket"
    key     = "state-files/terraform.tfstate"
    region  = "us-east-2"
    profile = "terraform"
  }
}