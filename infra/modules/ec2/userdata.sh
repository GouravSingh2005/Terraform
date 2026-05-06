#!/bin/bash

# update
apt update -y

# install docker
apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# install aws-cli
snap install aws-cli --classic

# install ruby and wget for CodeDeploy agent
apt install -y ruby-full wget
cd /home/ubuntu
wget https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent

# Get Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# CREATE .env FILE with application configuration and ECR information
cat <<EOF > /home/ubuntu/.env
DB_HOST=${rds_endpoint}
DB_PORT=3306
DB_USER=admin
DB_PASSWORD=MyStrongPassword123
DB_NAME=mydb

BUCKET_NAME=${bucket_name}
AWS_REGION=${region}

REDIS_HOST=${redis_host}
REDIS_PORT=6379

JWT_SECRET=secret123


ACCOUNT_ID=$ACCOUNT_ID
BACKEND_REPO_URL=${backend_repo_url}
FRONTEND_REPO_URL=${frontend_repo_url}
EOF

chown ubuntu:ubuntu /home/ubuntu/.env
