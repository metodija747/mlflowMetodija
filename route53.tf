resource "aws_acm_certificate" "mlflow_cert" {
  domain_name       = "${var.mlflow_subdomain}.${var.root_domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "mlflow_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.mlflow_cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "mlflow_cert_validation" {
  certificate_arn = aws_acm_certificate.mlflow_cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.mlflow_cert_validation : record.fqdn
  ]
}

resource "aws_route53_record" "mlflow_alias" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "${var.mlflow_subdomain}.${var.root_domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.mlflow_alb.dns_name
    zone_id                = aws_lb.mlflow_alb.zone_id
    evaluate_target_health = true
  }
}