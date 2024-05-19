output "pubip" {
    value = aws_instance.instance1.public_ip
}

output "pubdns" {
    value = aws_instance.instance1.public_dns    
}

output "privateip" {
    value = aws_instance.instance1.private_ip 
}

output "privatedns" {
    value = aws_instance.instance1.private_dns
  
}