terraform {
  backend "s3" {
    bucket         = "backends3bucket"
    key            = "states-files/terraform.tfstate"
    region         = "us-east-2"
    profile        = "terraform"
    dynamodb_table = "terraform-state-locking"
  }
}