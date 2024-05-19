resource "aws_security_group" "mysg" {
    name = var.sgname
  description = "security group for webapp"
  vpc_id = var.vpc
}

resource "aws_vpc_security_group_ingress_rule" "ingress1" {
    security_group_id = aws_security_group.mysg.id
    
    description = "ingress rule for http"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress2" {
    security_group_id = aws_security_group.mysg.id

    description = "ingress rule for https"
    from_port = 443
    to_port = 443
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress3" {
    security_group_id = aws_security_group.mysg.id

    description = "ingress rule for ssh"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "egress1" {
    security_group_id = aws_security_group.mysg.id

    ip_protocol = -1
    cidr_ipv4 = "0.0.0.0/0"
}