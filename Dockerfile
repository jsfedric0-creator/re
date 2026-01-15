FROM nginx:alpine

# نسخ ملف التكوين
COPY nginx.conf /etc/nginx/nginx.conf

# تشغيل Nginx
CMD ["nginx", "-g", "daemon off;"]
