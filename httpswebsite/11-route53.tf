# Look up the public hosted zone for tawanperry.top
data "aws_route53_zone" "main" {
  name         = "tawanperry.top."
  private_zone = false
}

resource "aws_route53_record" "alb_alias" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "app.tawanperry.top"
  type    = "A"

  alias {
    name                   = aws_lb.app1_alb.dns_name
    zone_id                = aws_lb.app1_alb.zone_id   # or keep the hard-coded Z35SX... if you want
    evaluate_target_health = true
  }
}

