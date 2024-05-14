resource "aws_key_pair" "tfkey" {
    key_name = "tfkey"
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "allows ssh+https"

  ingress {
    description = "ssh"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }
}

resource "aws_instance" "atlasec2tf" {
  ami               = var.ami
  availability_zone = var.AZ
  key_name          = aws_key_pair.tfkey
  instance_type     = var.itype
  
  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = var.ec2name
  }
}