# Dockerfile Wordpress

FROM debian:buster

RUN apt-get update
RUN apt-get -y install wget
RUN apt-get install -y	php7.3 \
			php-fpm \
			php-mysql \
			mariadb-client
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
COPY tools/wordpress_config.sh /etc/wordpress_config.sh
RUN chmod +x /etc/wordpress_config.sh
EXPOSE 9000
ENTRYPOINT ["bash", "/etc/wordpress_config.sh" ]
