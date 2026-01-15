FROM nginx:alpine

# Install required modules
RUN apk update && apk add --no-cache \
    nginx-mod-http-lua \
    nginx-mod-http-set-misc \
    curl \
    && rm -rf /var/cache/apk/*

# Copy configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create cache directory
RUN mkdir -p /tmp/nginx-cache && chmod 777 /tmp/nginx-cache

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
