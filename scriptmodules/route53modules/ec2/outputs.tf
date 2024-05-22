output "ec2privateip" {
    value = aws_instance.r53vm1.private_ip
}