########################
# ACM certificate for site.tawanperry.top
########################
resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.route53_record_name # e.g. "site.tawanperry.top"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

########################
# DNS record(s) used to validate the certificate
########################
resource "aws_route53_record" "app_cert_validation" {
  # Turn the domain_validation_options set into a nice map we can loop over
  for_each = {
    for dvo in aws_acm_certificate.app_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

########################
# Tell ACM that DNS validation is in place
########################
resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn = aws_acm_certificate.app_cert.arn

  validation_record_fqdns = [
    for r in aws_route53_record.app_cert_validation :
    r.fqdn
  ]
}
