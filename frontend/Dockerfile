FROM nginx:alpine

# Hapus file default nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy semua file frontend ke folder nginx
COPY . /usr/share/nginx/html

# Konfigurasi nginx untuk listen di port 8080
RUN sed -i 's/listen\s*80;/listen 8080;/g' /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
