#!/bin/bash


apt update -y


apt install -y docker.io
systemctl start docker
systemctl enable docker


snap install aws-cli --classic


usermod -aG docker ubuntu


sleep 10


ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="${region}"


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


aws ecr get-login-password --region $REGION | \
docker login --username AWS --password-stdin \
$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com


docker rm -f backend || true
docker rm -f frontend || true

docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest
docker pull $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest


docker run -d \
  --name backend \
  --restart always \
  -p 5000:5000 \
  --env-file /home/ubuntu/.env \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest


docker run -d \
  --name frontend \
  --restart always \
  -p 80:80 \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest