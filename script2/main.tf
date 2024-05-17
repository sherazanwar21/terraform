resource "aws_key_pair" "tfkey" {
    key_name = "tfkey"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJQPZMdpwG3RaVN30SL7u8XIwHssWTqMrr1SC8Fb2EVX2pCqBBmz6scjA0tuCp0SdMhS6JLVKuLxh0aWUkNNKrhYW1jvekD4gEUKEO2JFd4BNCX2V21k814cwytIy+ol6UN4YK/Ym+0Mw82dy+flC/tWpWZO20r0M7AGMhPi6qPrjMw/6CkZKyOGW9l6fYHH0u3ZECDB512UfiOrQrYFOnNq734c2m8BHCOdIaqKoAPubs8jNatTphCUJu/ppvBY3QV3FX3TcCiLu1M3NdtEpwvJRJuuFKktxd+Dvs1u17VApRCNjZaKwHTRxojJTX2kppQkHfVFPEGucYcr5qL8MsDRUlFRlQAGx5kYWvtHoOfdg7aiyVWnDY6j0MfqMsfYieylzJTYmluhD9EbF5OtE52jc4j7HIXQEdSdg9WjHdyO8YSoxCay5b6vanYCWkA3P9MP9RkMdBmAb6lVYEURuARCmux6OON8v6EDnICFYD4fCOBRj5LAFIea03DGKroz8= sherazanwar@Sherazs-MBP.fios-router.home"
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
  key_name          = aws_key_pair.tfkey.key_name
  instance_type     = var.itype
  user_data     = base64encode(<<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo vi /var/www/html/index.html
        sudo echo this $HOSTNAME >> /var/www/html/index.html
        EOF
        )
  
  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]

  tags = {
    Name = var.ec2name
  }
}