resource "aws_acm_certificate" "app_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name  = "app1-cert"
    Owner = "Tawan"
  }
}

resource "aws_acm_certificate_validation" "app_cert_validation" {
  certificate_arn = aws_acm_certificate.app_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.app_cert_validation : record.fqdn
  ]
}
