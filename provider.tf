terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "tf-state-mlflow-emteq-labs"
    key    = "terraform-eu-west-1.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region     = var.aws_region
}

data "aws_caller_identity" "current" {}
