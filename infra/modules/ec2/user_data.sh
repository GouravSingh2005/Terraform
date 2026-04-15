#!/bin/bash


apt  update -y
apt install -y docker.io awscli

systemctl start docker
systemctl enable docker

usermod -aG docker ec2-user


ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="${region}"


# CREATE .env FILE

cat <<EOF > /home/ec2-user/.env
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
  --env-file /home/ec2-user/.env \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/backend:latest


docker run -d \
  --name frontend \
  --restart always \
  -p 80:80 \
  $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/frontend:latest