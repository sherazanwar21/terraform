// data blocks for vpc and subnets
data "aws_vpc" "defvpc" {
  default = true
}

data "aws_subnet" "defsubnet1" {
  id = "subnet-074efb2392e3fdb13" #us-east-2a
}

data "aws_subnet" "defsubnet2" {
  id = "subnet-0db492f98057ed2da" #us-east-2b
}

// security group for alb and webserver
resource "aws_security_group" "albsg" {
  name   = "albsg"
  vpc_id = data.aws_vpc.defvpc.id

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
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
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// alb configuration
resource "aws_alb" "alb1" {
  internal           = false
  load_balancer_type = "application"
  name               = "atlasalb"
  security_groups    = [aws_security_group.albsg.id]
  subnets            = [data.aws_subnet.defsubnet1.id, data.aws_subnet.defsubnet2.id]

  depends_on = [aws_security_group.albsg]
}

resource "aws_alb_target_group" "tg1" {
  load_balancing_algorithm_type = "round_robin"
  name                          = "tg1"
  port                          = 80
  protocol                      = "HTTP"
  slow_start                    = 120
  target_type                   = "instance"
  vpc_id                        = data.aws_vpc.defvpc.id

  depends_on = [aws_alb.alb1]
}

resource "aws_alb_listener" "listener1" {
  load_balancer_arn = aws_alb.alb1.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg1.arn
  }

  port       = 80
  protocol   = "HTTP"
  depends_on = [aws_alb.alb1, aws_alb_target_group.tg1]
}

resource "aws_launch_template" "lt" {
  image_id               = "ami-09040d770ffe2224f"
  instance_type          = "t2.micro"
  name                   = "myfirstlt"
  vpc_security_group_ids = [aws_security_group.albsg.id]
  user_data = base64encode(<<-EOF
        #!/bin/bash
        sudo apt update
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo systemctl enable apche2
        echo "HI i am $HOSTNAME" >> /var/www/html/index.html
        EOF
  )
  depends_on = [aws_security_group.albsg]
}

// auto scalling group
resource "aws_autoscaling_group" "asg" {
  name                = "asg"
  max_size            = 5
  min_size            = 1
  desired_capacity    = 2
  health_check_type   = "ELB"
  target_group_arns   = [aws_alb_target_group.tg1.arn]
  vpc_zone_identifier = [data.aws_subnet.defsubnet1.id, data.aws_subnet.defsubnet2.id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
  depends_on = [aws_launch_template.lt, aws_alb_target_group.tg1]
}
