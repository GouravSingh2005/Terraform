#!/bin/bash

echo "Loading environment variables..."

source /home/ubuntu/.env

echo "Logging into ECR..."

aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin \
$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

echo "Pulling latest backend image..."

docker pull $BACKEND_REPO_URL:latest

echo "Pulling latest frontend image..."

docker pull $FRONTEND_REPO_URL:latest

echo "Starting backend container..."

docker run -d \
  -p 5000:5000 \
  --name backend \
  --env-file /home/ubuntu/.env \
  $BACKEND_REPO_URL:latest

echo "Starting frontend container..."

docker run -d \
  -p 80:80 \
  --name frontend \
  $FRONTEND_REPO_URL:latest

echo "Deployment completed successfully!"