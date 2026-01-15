FROM alpine:latest

# تثبيت Nginx مع وحدة RTMP
RUN apk update && apk add --no-cache \
    nginx \
    nginx-mod-rtmp \
    ffmpeg \
    curl \
    && rm -rf /var/cache/apk/*

# نسخ ملفات التكوين
COPY nginx.conf /etc/nginx/nginx.conf

# إنشاء مجلدات HLS
RUN mkdir -p /tmp/hls && chmod 777 /tmp/hls

# فتح المنافذ - بدون تعليقات في نفس السطر
EXPOSE 1935
EXPOSE 8080

# تشغيل Nginx
CMD ["nginx", "-g", "daemon off;"]
