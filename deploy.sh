#!/bin/bash

# Configuration
APP_NAME="bein-iptv-proxy"
IMAGE_NAME="ghcr.io/yourusername/bein-iptv-proxy:latest"
REGIONS="fra,iad,sin"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Deploying beIN IPTV Proxy to Koyeb${NC}"
echo "=========================================="

# Check if Koyeb CLI is installed
if ! command -v koyeb &> /dev/null; then
    echo -e "${YELLOW}⚠️  Koyeb CLI not found. Installing...${NC}"
    curl -fsSL https://cli.koyeb.com/install.sh | sh
fi

# Login to Koyeb
echo -e "${YELLOW}🔑 Logging in to Koyeb...${NC}"
koyeb auth login

# Check if app exists
if koyeb app describe $APP_NAME &> /dev/null; then
    echo -e "${YELLOW}📱 App exists, updating service...${NC}"
    
    # Update existing service
    koyeb service update $APP_NAME/proxy \
      --docker $IMAGE_NAME \
      --ports 8080:http \
      --routes /:8080 \
      --regions $REGIONS \
      --instance-type nano \
      --min-scale 2 \
      --max-scale 5 \
      --env TZ=UTC \
      --env NGINX_WORKER_PROCESSES=auto \
      --env CACHE_SIZE=1g
else
    echo -e "${YELLOW}🆕 Creating new app...${NC}"
    
    # Create new app
    koyeb app init $APP_NAME \
      --docker $IMAGE_NAME \
      --ports 8080:http \
      --routes /:8080 \
      --regions $REGIONS \
      --instance-type nano \
      --min-scale 2 \
      --max-scale 5 \
      --env TZ=UTC \
      --env NGINX_WORKER_PROCESSES=auto \
      --env CACHE_SIZE=1g
fi

echo ""
echo -e "${GREEN}✅ Deployment initiated!${NC}"
echo ""
echo -e "${GREEN}📋 Next steps:${NC}"
echo "1. Wait for deployment to complete:"
echo "   koyeb service get $APP_NAME/proxy"
echo ""
echo "2. Check logs:"
echo "   koyeb service logs $APP_NAME/proxy"
echo ""
echo "3. Get app URL:"
echo "   koyeb app describe $APP_NAME"
echo ""
echo "4. Monitor health:"
echo "   curl https://$APP_NAME.koyeb.app/health"
echo ""
echo "5. Access playlist:"
echo "   https://$APP_NAME.koyeb.app/playlist.m3u"
