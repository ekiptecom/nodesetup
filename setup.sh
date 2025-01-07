#!/bin/bash

# Git kullanıcı kimlik bilgilerini tanımlayın
email=$GIT_EMAIL
password=$GIT_PASSWORD


# Nginx kurulumu
sudo apt-get update
sudo apt-get install -y nginx

# NVM kurulumu
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc

# Node.js 17.3.0 kurulumu ve varsayılan olarak ayarlanması
nvm install v17.3.0
nvm alias default 17.3.0
nvm use default

# PM2 kurulumu
npm install pm2 -g

# ŞehirApp klasörünün oluşturulması ve git yapılandırması
mkdir sehirapp
cd sehirapp
git init

# Git yapılandırma ayarları
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 100M

# Remote repository ekleme ve ana şubeyi çekme
git remote add origin https://$email:$password@github.com/ekiptecom/sehirapp.git
git fetch origin

echo "https://$email:$password@github.com/ekiptecom/sehirapp.git" | git credential-store --file ~/.git-credentials store
git checkout main

npm install

# İşlem tamamlandı mesajı
echo "ŞehirApp kurulumu tamamlandı!"

# node.config.cjs çalıştır pm2
pm2 start node.config.cjs

echo "PM2 başlatıldı!"