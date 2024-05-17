#creating a vpc 
resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpccidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpcname
  }
}

#creating a public subnet
resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.pubcidr
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"

  tags = {
    Name = var.pubsubnetname
  }
}

#creating a private subnet 
resource "aws_subnet" "privatesubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.privcidr
  map_public_ip_on_launch = false
  availability_zone       = "us-east-2c"

  tags = {
    Name = var.privsubnetname
  }
}

#creating internet gateway
resource "aws_internet_gateway" "tfig1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = var.igname
  }
}

#creating a route table with vpc
resource "aws_route_table" "tfpublicrt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = var.pubroutecidr
    gateway_id = aws_internet_gateway.tfig1.id
  }

  tags = {
    Name = var.publicroutetable
  }
}

#assosiating subnets to route table
resource "aws_route_table_association" "tfpublicrta" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.tfpublicrt.id
}

#creating a nat gatway for a private subnet
resource "aws_nat_gateway" "tfngw" {
  subnet_id         = aws_subnet.privatesubnet1.id
  connectivity_type = "private"

  tags = {
    Name = var.ngname
  }
}

#creating security groups for vpc
resource "aws_security_group" "tfsg" {
  name        = var.vpcsg
  description = "security group allowing SSH, HTTPS, and NFS"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating NACL for VPC
resource "aws_network_acl" "NACL" {
  vpc_id = aws_vpc.vpc1.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 2049
    to_port    = 2049
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 2049
    to_port    = 2049
  }
  tags = {
    Name = var.vpcnacl
  }
}

