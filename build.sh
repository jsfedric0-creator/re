#!/bin/bash

# Configuration
IMAGE_NAME="ghcr.io/yourusername/bein-iptv-proxy"
VERSION="latest"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Building beIN IPTV Proxy for Koyeb${NC}"
echo "========================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running${NC}"
    exit 1
fi

# Build Docker image
echo -e "${YELLOW}📦 Building Docker image...${NC}"
docker build -t $IMAGE_NAME:$VERSION -t $IMAGE_NAME:$(date +%Y%m%d) .

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker image built successfully${NC}"

# Test locally
echo -e "${YELLOW}🔧 Testing locally...${NC}"
docker run --rm -d -p 8080:8080 --name bein-test $IMAGE_NAME:$VERSION

sleep 3

# Test health endpoint
if curl -s http://localhost:8080/health | grep -q "OK"; then
    echo -e "${GREEN}✅ Local test passed${NC}"
    docker stop bein-test > /dev/null
else
    echo -e "${RED}❌ Local test failed${NC}"
    docker stop bein-test > /dev/null
    exit 1
fi

# Login to GitHub Container Registry
echo -e "${YELLOW}🔑 Logging in to GitHub Container Registry...${NC}"
echo $GHCR_TOKEN | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Registry login failed${NC}"
    exit 1
fi

# Push to registry
echo -e "${YELLOW}📤 Pushing to GitHub Container Registry...${NC}"
docker push $IMAGE_NAME:$VERSION
docker push $IMAGE_NAME:$(date +%Y%m%d)

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Image pushed successfully${NC}"
    echo ""
    echo -e "${GREEN}📋 Deployment URLs:${NC}"
    echo "   Image: $IMAGE_NAME:$VERSION"
    echo "   Health: https://your-app.koyeb.app/health"
    echo "   Playlist: https://your-app.koyeb.app/playlist.m3u"
    echo "   Dashboard: https://app.koyeb.com/apps"
else
    echo -e "${RED}❌ Push failed${NC}"
    exit 1
fi
