FROM debian:buster

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install nginx -y vim curl openssl \
 && mkdir -p /etc/nginx/ssl \
 && apt-get clean \
 && openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Nice/L=Nice/O=42/OU=42/CN=chmassa.42.fr/UID=login" \
 && mkdir -p /var/run/nginx \
 && chmod 755 /var/www/html \
 && chown -R www-data:www-data /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
# EXPOSE 443
CMD [ "nginx", "-g", "daemon off;" ]
