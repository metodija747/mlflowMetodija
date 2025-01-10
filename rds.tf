resource "aws_db_subnet_group" "mlflow_rds_subnet_group" {
  name = "mlflow-rds-subnet-group-eu-west-1"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
  tags = {
    Name = "mlflow-rds-subnet-group-eu-west-1"
  }
}

resource "aws_db_instance" "mlflow_rds" {
  username          = var.db_username
  password          = var.db_password
  instance_class           = var.db_instance_class
  db_subnet_group_name     = aws_db_subnet_group.mlflow_rds_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  publicly_accessible      = false
  skip_final_snapshot   = true
  storage_encrypted     = true
  copy_tags_to_snapshot = true


  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "mlflow-rds-instance-eu-west-1"
  }
}
