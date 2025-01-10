resource "aws_iam_role" "ec2_role" {
  name = "mlflow-ec2-role-eu-west-1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  tags = {
    Name = "mlflow-ec2-role-eu-west-1"
  }
}

data "aws_iam_policy_document" "ec2_s3_limited_access_policy" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
    effect    = "Allow"
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "ec2_ecr_limited_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages"
    ]
    resources = [data.aws_ecr_repository.mlflow_repository.arn]
  }
}

resource "aws_iam_role_policy" "ec2_s3_limited_access" {
  name   = "mlflow-ec2-limited-s3-access-eu-west-1"
  role   = aws_iam_role.ec2_role.name
  policy = data.aws_iam_policy_document.ec2_s3_limited_access_policy.json
}

resource "aws_iam_role_policy" "ec2_ecr_access" {
  name   = "mlflow-ec2-ecr-access-eu-west-1"
  role   = aws_iam_role.ec2_role.name
  policy = data.aws_iam_policy_document.ec2_ecr_limited_policy.json
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "mlflow-ec2-instance-profile-eu-west-1"
  role = aws_iam_role.ec2_role.name
}
