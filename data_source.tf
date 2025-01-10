data "aws_vpc" "default" {
  id = var.default_vpc_id
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_route53_zone" "root_zone" {
  name         = var.root_domain_name
  private_zone = false
}

data "aws_availability_zones" "available" {}

data "aws_ecr_repository" "mlflow_repository" {
  name = "mlflow-artifacts-v1-2025-01-08"
}