# 11-route53.tf

resource "aws_route53_record" "alb_alias_https" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "site.tawanperry.top"
  type    = "A"

  alias {
    name                   = aws_lb.app1_alb.dns_name
    zone_id                = aws_lb.app1_alb.zone_id
    evaluate_target_health = true
  }
}
