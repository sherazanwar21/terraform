# module "iam" {
#   source = "./modules/iam"

#   group = "group1"
# }

# module "ec2" {
#     source = "./modules/ec2"

#     az = "us-east-2b"
#     instancename = module.iam.username
# }

module "myec2" {
  source = "./modules2/ec2"

  ec2name    = "instance1"
  ami        = "ami-09040d770ffe2224f"
  itype      = "t2.micro"
  az         = "us-east-2c"
  key        = "newkey"
  sgid       = module.mysg.sgid
  depends_on = [module.mysg]
}

module "mysg" {
  source = "./modules2/sg"

  sgname = "mysg"
  vpc    = "vpc-09c79048eef847fac"
}

module "backend" {
  source = "./modules2/backend"

  bucketname   = "sherazs3bucket1"
  dynamodbname = "table1"
  versstatus   = "Enabled"
}