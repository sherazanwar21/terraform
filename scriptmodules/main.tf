// 1stscript
# module "iam" {
#   source = "./modules/iam"

#   group = "group1"
# }

# module "ec2" {
#     source = "./modules/ec2"

#     az = "us-east-2b"
#     instancename = module.iam.username
# }

// 2ndscipt
# module "myec2" {
#   source = "./modules2/ec2"

#   ec2name    = "instance1"
#   ami        = "ami-09040d770ffe2224f"
#   itype      = "t2.micro"
#   az         = "us-east-2c"
#   key        = "newkey"
#   sgid       = module.mysg.sgid
#   depends_on = [module.mysg]
# }

# module "mysg" {
#   source = "./modules2/sg"

#   sgname = "mysg"
#   vpc    = "vpc-09c79048eef847fac"
# }

# module "backend" {
#   source = "./modules2/backend"

#   bucketname   = "sherazs3bucket1"
#   dynamodbname = "table1"
#   versstatus   = "Enabled"
# }

// route53 module script
# module "ec2" {
#   source = "./route53modules/ec2"

#   sgid       = module.sg.sgid
#   subnet_id  = module.vpc.subnet_id
#   depends_on = [module.sg, module.vpc]
# }

# module "sg" {
#   source = "./route53modules/sg"

#   vpcid      = module.vpc.vpcid
#   depends_on = [module.vpc]

# }

# module "vpc" {
#   source = "./route53modules/vpc"

# }

# module "route53" {
#   source = "./route53modules/route53"

#   vpcid        = module.vpc.vpcid
#   ec2privateip = module.ec2.ec2privateip
#   depends_on   = [module.vpc, module.ec2]
# }

// asg_alb modules
module "alb" {
  source = "./alb_asgmodules/alb"

  sgid = module.sg.sgid
  sub1 = module.vpc.sub1
  sub2 = module.vpc.sub2
  vpcid = module.vpc.vpcid

  depends_on = [ module.sg ]
}

module "asg" {
  source = "./alb_asgmodules/asg"

  sgid = module.sg.sgid
  tg1 = module.alb.tg1
  sub1 = module.vpc.sub1
  sub2 = module.vpc.sub2
  
  depends_on = [ module.sg, module.alb ]
}

module "sg" {
  source = "./alb_asgmodules/sg"

  vpcid = module.vpc.vpcid
}

module "vpc" {
  source = "./alb_asgmodules/vpc"
}

