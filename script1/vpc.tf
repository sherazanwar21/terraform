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


