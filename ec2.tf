data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "mlflow_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  # Templatize user_data
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    htpasswd_commands     = local.htpasswd_commands
    db_username           = var.db_username
    db_password           = var.db_password
    db_name               = var.db_name
    db_host               = aws_db_instance.mlflow_rds.address
    bucket_name           = aws_s3_bucket.mlflow_artifacts.bucket
    mlflow_image          = var.mlflow_image
    aws_region            = var.aws_region
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  })

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "mlflow-ec2-eu-west-1"
  }
}
