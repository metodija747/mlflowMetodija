resource "aws_s3_bucket" "mlflow_artifacts" {
  bucket = var.bucket_name
  tags = {
    Name = "mlflow-artifacts-bucket-eu-west-1"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "mlflow_bucket_policy" {
  bucket = aws_s3_bucket.mlflow_artifacts.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowMlflowEC2RoleAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/mlflow-ec2-role-eu-west-1"
        },
        Action    = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource  = [
          "${aws_s3_bucket.mlflow_artifacts.arn}",
          "${aws_s3_bucket.mlflow_artifacts.arn}/*"
        ]
      }
    ]
  })
}
