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

// security group
resource "aws_security_group" "sg1" {
  description = "security group for ssh and https"
  name        = "sg1"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// route53 hosted private zone
resource "aws_route53_zone" "privatezone" {
  name          = "atlas.local"
  force_destroy = true

  vpc {
    vpc_id = aws_vpc.vpc1.id
  }
  depends_on = [aws_vpc.vpc1]
}

// creating an instance 
resource "aws_instance" "r53vm1" {
  ami                    = "ami-02bf8ce06a8ed6092"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = aws_subnet.publicsubnet1.id
  user_data              = <<-EOF
        #!/bin/bash
        sudo yum update
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "Hi this is $HOSTNAME" >> /var/www/html/index.html
        EOF

  depends_on = [aws_security_group.sg1]

  tags = {
    Name = "r53vm1"
  }
}

// record connected to instance's private ip
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.privatezone.id
  name    = "atlas.local"
  type    = "A"
  records = [aws_instance.r53vm1.private_ip]
  ttl     = 300

  depends_on = [aws_instance.r53vm1]
}




