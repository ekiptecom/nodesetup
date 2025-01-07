#!/bin/bash

# Hedef dosya yolu
nginx_sites_available="/etc/nginx/sites-available/sehirapp.com"
nginx_sites_enabled="/etc/nginx/sites-enabled/sehirapp.com"

# Nginx yapılandırma dosyasını oluştur
cat <<EOL > "$nginx_sites_available"
server {
    listen 80;
    server_name api.sehirapp.com;
    client_max_body_size 100M;
    location / {
       proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
       proxy_set_header Host \$host;
       proxy_pass http://127.0.0.1:3000;
       proxy_http_version 1.1;
       proxy_set_header Upgrade \$http_upgrade;
       proxy_set_header Connection "upgrade";
    }
}
EOL

# Sites-enabled klasörüne sembolik link oluştur
ln -s "$nginx_sites_available" "$nginx_sites_enabled"

# Nginx yapılandırmasını test et
nginx -t

# Nginx'i yeniden yükle
systemctl reload nginx

echo "Nginx yapılandırması başarıyla oluşturuldu ve yeniden yüklendi."