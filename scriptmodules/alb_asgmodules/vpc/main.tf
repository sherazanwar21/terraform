// data blocks for vpc and subnets
data "aws_vpc" "defvpc" {
  default = true
}

data "aws_subnet" "defsubnet1" {
  id = "subnet-074efb2392e3fdb13" #us-east-2a
}

data "aws_subnet" "defsubnet2" {
  id = "subnet-0db492f98057ed2da" #us-east-2b
}