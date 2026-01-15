#!/bin/bash

# Build Docker image
docker build -t yourusername/iptv-proxy -f nginx/Dockerfile .

# Test locally
docker-compose up -d

# Push to Docker registry
docker push yourusername/iptv-proxy:latest

# Deploy to Koyeb
koyeb service create iptv-proxy \
  --docker yourusername/iptv-proxy \
  --ports 8080:http \
  --routes /:8080 \
  --instances 2
