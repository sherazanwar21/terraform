resource "aws_instance" "atlasec2tf" {
  ami                    = "ami-0f30a9c3a48f3fa79"
  instance_type          = "t2.micro"
  key_name               = "newkey"
  availability_zone      = "us-east-2c"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  user_data              = <<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo vi /var/www/html/index.html
        sudo echo this $HOSTNAME >> /var/www/html/index.html
        EOF
  root_block_device {
    volume_size = 9
  }
  depends_on = [ aws_security_group.sg1 ]
  tags = {
    Name = "atlasec2tf"
  }
}

resource "aws_security_group" "sg1" {
  description = "security group"
  name        = "allow_httpd-ssh"

  ingress {
    description = "httpd"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "ALL"
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}