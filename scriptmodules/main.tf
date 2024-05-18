module "iam" {
  source = "./modules/iam"

  group = "group1"
}

module "ec2" {
    source = "./modules/ec2"

    az = "us-east-2b"
    instancename = module.iam.username
}


