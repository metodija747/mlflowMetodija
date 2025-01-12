#!/bin/bash
set -ex

# # 1) Unattended upgrades
apt-get update -y

# 2) Docker, Nginx,  Python tools
apt-get install -y docker.io nginx apache2-utils python3-pip
systemctl enable docker
systemctl start docker

pip3 install --upgrade pip
pip3 install awscli mlflow psycopg2-binary boto3

# 3) Basic Auth with .htpasswd
rm -f /etc/nginx/.htpasswd
${htpasswd_commands}

# 4) Nginx config: listen on port 80, forward to 127.0.0.1:5000
cat > /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 768;
}

http {
    server {
        listen 80;
        auth_basic "Restricted Access";
        auth_basic_user_file /etc/nginx/.htpasswd;

        location / {
            proxy_pass http://127.0.0.1:5000;
        }
    }
}
EOF

systemctl enable nginx
systemctl restart nginx

# 5) Login to ECR (if your Docker image is in ECR)
aws ecr get-login-password --region ${aws_region} \
 | docker login --username AWS --password-stdin $(echo ${mlflow_image} | cut -d'/' -f1)

# 6) Run the MLflow Docker container
docker run -d -p 5000:5000 \
  -e AWS_DEFAULT_REGION="${aws_region}" \
  -e DB_USERNAME="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  -e DB_HOST="${db_host}" \
  -e DB_NAME="${db_name}" \
  -e BUCKET_NAME="${bucket_name}" \
  --restart always \
  --name mlflow-server \
  "${mlflow_image}"
