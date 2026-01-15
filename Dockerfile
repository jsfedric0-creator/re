FROM nginx:alpine

# نسخ التكوين
COPY nginx.conf /etc/nginx/nginx.conf

# التأكد من صلاحيات المجلدات
RUN mkdir -p /var/cache/nginx && \
    chown -R nginx:nginx /var/cache/nginx && \
    chmod -R 755 /var/cache/nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
