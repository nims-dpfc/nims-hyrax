FROM nginx:stable-alpine

# Install Certbot
RUN apk add --no-cache --upgrade certbot certbot-nginx

# Ensure nginx is running
RUN /etc/nginx/sbin/nginx