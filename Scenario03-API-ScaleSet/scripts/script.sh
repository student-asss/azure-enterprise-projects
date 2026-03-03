#!/bin/bash
apt update -y
apt install -y nginx
echo "API instance running on $(hostname)" > /var/www/html/index.html
systemctl enable nginx
systemctl restart nginx
