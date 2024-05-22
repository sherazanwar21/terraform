// launch template
resource "aws_launch_template" "lt" {
  image_id               = "ami-09040d770ffe2224f"
  instance_type          = "t2.micro"
  name                   = "myfirstlt"
  vpc_security_group_ids = [var.sgid]
  user_data = base64encode(<<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apche2
        echo "HI i am $HOSTNAME" >> /var/www/html/index.html
        EOF
  )
}

// auto scaling group
resource "aws_autoscaling_group" "asg" {
  name                = "asg"
  max_size            = 5
  min_size            = 1
  desired_capacity    = 2
  health_check_type   = "ELB"
  target_group_arns   = [var.tg1]
  vpc_zone_identifier = [var.sub1, var.sub2]

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
  depends_on = [ aws_launch_template.lt ]
}