output "rds_endpoint" {
  value = aws_db_instance.mlflow_rds.address
}

output "s3_bucket" {
  value = aws_s3_bucket.mlflow_artifacts.bucket
}
