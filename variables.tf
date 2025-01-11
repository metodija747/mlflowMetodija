variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "default_vpc_id" {
  type    = string
  default = "vpc-116b7f77"
}

variable "public_subnet_cidr_1" {
  type    = string
  default = "172.31.240.0/24"
}

variable "public_subnet_cidr_2" {
  type    = string
  default = "172.31.241.0/24"
}

variable "private_subnet_cidr_1" {
  type    = string
  default = "172.31.242.0/24"
}

variable "private_subnet_cidr_2" {
  type    = string
  default = "172.31.243.0/24"
}

variable "mlflow_users" {
  type = list(object({
    username = string
    password = string
  }))
  default = [
    { username = "data_sci_1", password = "Password123!" },
    { username = "data_sci_2", password = "Password123!" },
    { username = "data_sci_3", password = "Password123!" },
    { username = "data_sci_4", password = "Password123!" },
    { username = "data_sci_8", password = "Password123!" }
  ]
}

variable "db_username" {
  type    = string
  default = "mlflow"
}

variable "db_password" {
  type    = string
  default = "Mlflowpassword123!"
}

variable "db_name" {
  type    = string
  default = "mlflowdb"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}


variable "bucket_name" {
  type    = string
  default = "my-mlflow-artifacts-v1-20250108-unique"
}

variable "mlflow_image" {
  type        = string
  default     = "274393375000.dkr.ecr.eu-west-1.amazonaws.com/mlflow-artifacts-v1-2025-01-08:latest"
  description = "Official MLflow image"
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "root_domain_name" {
  type    = string
  default = "emteqmlflow.com"
}

variable "mlflow_subdomain" {
  type    = string
  default = "labs"
}