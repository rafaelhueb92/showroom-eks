resource "aws_acm_certificate" "this" {
  domain_name = "${var.project_name}.com"
  validation_method = "DNS"

}
