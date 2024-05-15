resource "aws_instance" "vm10" {
  ami                    = "ami-02bf8ce06a8ed6092"
  availability_zone      = "us-east-2c"
  instance_type          = "t2.micro"
  key_name               = "newkey"
  vpc_security_group_ids = [aws_security_group.sg10.id]
  depends_on             = [aws_security_group.sg10]

  tags = {
    Name = "vm10"
  }
}

resource "aws_security_group" "sg10" {
  name        = "allow https"
  description = "Allow http inbound and all outbound traffic"

  tags = {
    Name = "allowhttps"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowhttps" {
  security_group_id = aws_security_group.sg10.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.sg10.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}