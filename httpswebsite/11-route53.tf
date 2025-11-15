resource "aws_route53_record" "alb_alias_https" {
  zone_id = var.route53_zone_id
  name    = var.route53_record_name # e.g. "site.tawanperry.top"
  type    = "A"

  alias {
    name                   = aws_lb.app1_alb.dns_name
    zone_id                = aws_lb.app1_alb.zone_id
    evaluate_target_health = true
  }
}
