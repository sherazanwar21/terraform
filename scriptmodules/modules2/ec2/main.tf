resource "aws_instance" "instance1" {
  ami = var.ami
  instance_type = var.itype
  availability_zone = var.az
  key_name = var.key
  vpc_security_group_ids = [var.sgid ]
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo vi /var/www/html/index.html
    sudo echo this $HOSTNAME >> /var/www/html/index.html
    EOF

    tags = {
        Name = var.ec2name
    }
}