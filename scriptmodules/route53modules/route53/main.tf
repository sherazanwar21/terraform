// route53 hosted private zone
resource "aws_route53_zone" "privatezone" {
  name          = "atlas.local"
  force_destroy = true

  vpc {
    vpc_id = var.vpcid
  }
}

// record connected to instance's private ip
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.privatezone.id
  name    = "atlas.local"
  type    = "A"
  records = [var.ec2privateip]
  ttl     = 300
}