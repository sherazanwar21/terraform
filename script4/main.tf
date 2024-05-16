resource "aws_launch_template" "lt" {
  name          = "launch_template-1"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key
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
  #vpc_security_group_ids = 

  placement {
    availability_zone = var.availability_zone
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "auto-scaling-1"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  #vpc_zone_identifier = [aws_subnet.privatesubnet.id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }

  depends_on = [aws_launch_template.lt]
}