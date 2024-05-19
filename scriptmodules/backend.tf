terraform {
  backend "s3" {
    bucket = "sherazs3bucket1"
    key = "states/terraform.tfstate"
    region = "us-east-2"
    profile = "terraform"
    dynamodb_table = "table1"
  }
}