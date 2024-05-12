resource "aws_instance" "vm1" {
  ami               = var.ami_id
  availability_zone = var.az
  key_name          = var.key
  instance_type     = var.itype
  vpc_security_group_ids = [
    "sg-04b2e6259ebc985a5",
    "sg-028aa47bac49dcc44",
    aws_security_group.tfsg1.id
  ]
  depends_on = [aws_security_group.tfsg1]

  tags = {
    Name = var.ec2name
    iac  = "terraform"
  }
}

# resource "aws_ec2_instance_state" "vm1state" {
#   instance_id = aws_instance.vm1.id
#   state       = "running"
# }

resource "aws_security_group" "tfsg1" {
  name        = "https"
  description = "allow https"
  vpc_id      = "vpc-09c79048eef847fac"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow indbount https"
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }
}