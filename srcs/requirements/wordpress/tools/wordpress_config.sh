# wordpress_config.sh

# Colors
GREEN="\033[32m"
B_GREEN="\033[1;32m"
B_BLUE="\033[1;34m"
RESET="\033[0m"


echo -e "${B_GREEN}################ Starting script 'wordpress_config.sh' ###########################################################${RESET}"

sleep 10
mkdir -p /run/php

echo -e "${B_BLUE}Modify php config file 'www.conf'${RESET}"
sed -i'' 's|^listen = /run/php/php7.3-fpm.sock|listen = wordpress:9000|' /etc/php/7.3/fpm/pool.d/www.conf
sed -i'' 's/;clear_env = no/clear_env = no/' /etc/php/7.3/fpm/pool.d/www.conf
echo -e "${GREEN}DONE${RESET}"

if [ -f "/var/www/wordpress/wp-config.php" ]; then
	echo -e "${B_BLUE}wordpress is already configured${RESET}"
else
	cd /var/www/wordpress
	echo -e "${B_BLUE}wp core download${RESET}"
	wp core download --allow-root
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}wp config create${RESET}"
	wp config create --allow-root\
		--dbname=$MYSQL_HOSTNAME \
		--dbuser=$MYSQL_USER \
		--dbpass=$MYSQL_USER_PASSWORD \
		--dbhost=mariadb_inception42 --path='/var/www/wordpress'
	 
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}wp core install${RESET}"
	wp core install --allow-root\
		--url=$DOMAIN_NAME \
		--title=$WP_DB_NAME \
		--admin_user=$WP_DB_USER \
		--admin_password=$MYSQL_USER_PASSWORD \
		--admin_email=$WP_DB_EMAIL
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}wp user create${RESET}"
	wp user create --allow-root \
		$USER_NAME \
		$USER_EMAIL \
		--user_pass=$USER_PASSWORD \
		--role=editor
	
fi
/usr/sbin/php-fpm7.3 -F
