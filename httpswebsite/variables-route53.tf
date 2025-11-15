variable "route53_zone_id" {
  description = "ID of the Route 53 Hosted Zone for the domain"
  type        = string
}

variable "route53_record_name" {
  description = "DNS record name for the app (e.g. app.tawanmperry.com)"
  type        = string
}
