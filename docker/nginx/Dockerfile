FROM nginx:stable-alpine

# Copy our configuration
COPY ngdrdemo.cottagelabs.com.conf /etc/nginx/conf.d/ngdrdemo.cottagelabs.com.conf
COPY .htpasswd /etc/nginx/conf.d/.htpasswd

# Install Certbot
RUN apk add --no-cache --upgrade certbot certbot-nginx