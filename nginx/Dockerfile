FROM nginx:alpine

# Install required modules
RUN apk update && apk add \
    nginx-mod-http-lua \
    nginx-mod-http-set-misc \
    nginx-mod-http-headers-more \
    curl \
    ca-certificates

# Copy custom configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Create cache directory
RUN mkdir -p /tmp/nginx-cache

EXPOSE 80 1935

CMD ["nginx", "-g", "daemon off;"]
