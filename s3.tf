resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket = var.bucket_name
  tags = {
    Name = "mlflow-artifacts-bucket-eu-west-1"
  }
  lifecycle {
    prevent_destroy = true
  }
}