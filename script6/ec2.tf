# resource "aws_instance" "myinstance" {
#   availability_zone = "us-east-2c"
#   ami               = "ami-09040d770ffe2224f"
#   instance_type     = "t2.micro"
#   tags = {
#     Name = "testec2"
#   }
# }