FROM nginx:stable-alpine

# Copy our configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY .htpasswd /etc/nginx/conf.d/.htpasswd

# Install Certbot
RUN apk add --no-cache --upgrade certbot certbot-nginx