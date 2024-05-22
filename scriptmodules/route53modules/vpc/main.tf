/// vpc
resource "aws_vpc" "vpc1" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc1"
  }
}

// 2 public subets
resource "aws_subnet" "publicsubnet1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsubnet1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "192.168.2.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsubnet2"
  }
}

// internet gateway
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw1"
  }
}

// route table
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }
  tags = {
    Name = "rt1"
  }
}

// route table association
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.rt1.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.rt1.id
}