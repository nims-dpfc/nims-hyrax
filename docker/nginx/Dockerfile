FROM nginx:stable-alpine

# Install Certbot
RUN apk add --no-cache --upgrade certbot certbot-nginx
RUN certbot --nginx certonly -d ngdrdemo.cottagelabs.com

# Reload NGINX
RUN nginx -s reload