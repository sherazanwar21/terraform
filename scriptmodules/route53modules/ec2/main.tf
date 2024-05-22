// creating an instance 
resource "aws_instance" "r53vm1" {
  ami                    = "ami-02bf8ce06a8ed6092"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [var.sgid]
  subnet_id              = var.subnet_id
  user_data              = <<-EOF
        #!/bin/bash
        sudo yum update
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        echo "Hi this is $HOSTNAME" >> /var/www/html/index.html
        EOF

  tags = {
    Name = "r53vm1"
  }
}