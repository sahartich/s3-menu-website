resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "menu.${var.domain_name}"
  type    = "A"
  alias {
    name                   = "s3-website-${var.region}.amazonaws.com"
    zone_id                = aws_s3_bucket.main.hosted_zone_id
    evaluate_target_health = false
  }
}