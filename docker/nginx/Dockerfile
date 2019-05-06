FROM nginx:stable-alpine

# Copy our configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY ssl.conf /etc/nginx/ssl.conf
COPY .htpasswd /etc/nginx/conf.d/.htpasswd

# Install Certbot
RUN apk add --no-cache --upgrade certbot certbot-nginx
COPY hyrax_2018.pem /etc/ssl/certs/hyrax_2018.pem
COPY hyrax_2018_nopass.key /etc/ssl/private/hyrax_2018_nopass.key

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
