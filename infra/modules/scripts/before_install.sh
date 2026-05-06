#!/bin/bash

echo "Stopping old containers..."

docker rm -f backend || true
docker rm -f frontend || true

echo "Old containers removed"