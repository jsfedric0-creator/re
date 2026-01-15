# Multi-stage build for smaller image
FROM alpine:3.18 AS builder

# Install build dependencies
RUN apk add --no-cache \
    nginx \
    nginx-mod-http-lua \
    nginx-mod-http-set-misc \
    nginx-mod-http-headers-more \
    curl \
    ca-certificates \
    && mkdir -p /tmp/nginx-cache

# Create nginx user
RUN adduser -D -g 'www' www \
    && mkdir /www \
    && chown -R www:www /var/lib/nginx \
    && chown -R www:www /www

# Copy configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create health check script
RUN echo '#!/bin/sh\ncurl -f http://localhost:8080/health || exit 1' > /healthcheck.sh \
    && chmod +x /healthcheck.sh

# Final stage
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache \
    nginx \
    nginx-mod-http-lua \
    nginx-mod-http-set-misc \
    nginx-mod-http-headers-more \
    curl \
    ca-certificates \
    tzdata \
    && rm -rf /var/cache/apk/*

# Copy from builder
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /healthcheck.sh /healthcheck.sh

# Create necessary directories
RUN mkdir -p /tmp/nginx-cache \
    && mkdir -p /var/log/nginx \
    && touch /var/log/nginx/access.log /var/log/nginx/error.log \
    && chmod -R 755 /tmp/nginx-cache \
    && chown -R nginx:nginx /tmp/nginx-cache /var/log/nginx

# Add nginx user
RUN adduser -D -g 'www' www \
    && chown -R www:www /var/lib/nginx

# Expose ports
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /healthcheck.sh

# Run as non-root
USER www

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
