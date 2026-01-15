#!/bin/bash

# بناء الصورة
docker build -t bein-restream:latest .

# تشغيل محلي للاختبار
docker run -d \
  -p 1935:1935 \
  -p 8080:8080 \
  --name bein-test \
  bein-restream:latest

echo "✅ Restreaming server started!"
echo "📡 RTMP: rtmp://localhost:1935/live/"
echo "🌐 HTTP: http://localhost:8080/"
echo "📺 HLS: http://localhost:8080/hls/"
echo "📊 Stats: http://localhost:8080/stats"
