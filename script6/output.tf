output "ec2pubid" {
  value = aws_instance.myinstance.public_ip
}

output "ec2id" {
  value = aws_instance.myinstance.id
}

output "ec2pubdns" {
  value = aws_instance.myinstance.public_dns
}

output "ec2tags" {
  value = aws_instance.myinstance.tags
}