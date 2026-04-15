#!/bin/bash

# update
apt update -y

# install docker
apt install -y docker.io
systemctl start docker
systemctl enable docker

# install aws cli (stable way)
snap install aws-cli --classic

# add ubuntu user to docker group
usermod -aG docker ubuntu

# wait for aws cli (important)
sleep 10

# get account id
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="${region}"
export AWS_DEFAULT_REGION="$REGION"
BACKEND_REPO_URL="${backend_repo_url}"
FRONTEND_REPO_URL="${frontend_repo_url}"

# CREATE .env FILE
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
EOF

# login to ECR
aws ecr get-login-password --region $REGION | \
docker login --username AWS --password-stdin \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# remove old containers
docker rm -f backend || true
docker rm -f frontend || true

# pull latest images
docker pull $BACKEND_REPO_URL:latest
docker pull $FRONTEND_REPO_URL:latest

# run backend
docker run -d \
  --name backend \
  --restart always \
  -p 5000:5000 \
  --env-file /home/ubuntu/.env \
  $BACKEND_REPO_URL:latest

# run frontend
docker run -d \
  --name frontend \
  --restart always \
  -p 80:80 \
  $FRONTEND_REPO_URL:latest