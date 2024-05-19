provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "terraform"
}