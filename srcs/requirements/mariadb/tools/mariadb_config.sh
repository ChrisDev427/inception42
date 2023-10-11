# config.sh mariadb
# Colors

GREEN="\033[32m"
B_GREEN="\033[1;32m"
B_BLUE="\033[1;34m"
RESET="\033[0m"

echo -e "${B_GREEN}################ Starting script 'mariadb_config.sh' ###########################################################${RESET}"

echo -e "${B_BLUE}Modify 50-server.cnf${RESET}"
sed -i'' '/bind-address/ s/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
echo -e "${GREEN}DONE${RESET}"

if [ -d "/var/lib/mysql/mariadb" ]; then
  echo -e "${B_BLUE}Database already exist.${RESET}"
else
  echo -e "${B_BLUE}Creating database.${RESET}"
	echo -e "${B_BLUE}Starting mysql${RESET}"
	service mysql start
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}mysql configuration${RESET}"
	mysql -e "CREATE DATABASE \`$MYSQL_HOSTNAME\`; \
		CREATE USER \`$MYSQL_USER\`@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
		GRANT ALL PRIVILEGES ON \`$MYSQL_HOSTNAME\`.* TO \`$MYSQL_USER\`@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
		UPDATE mysql.user SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD')WHERE User='root'; \
		DROP DATABASE IF EXISTS test; \
		DELETE FROM mysql.user WHERE User=''; \
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN('localhost','127.0.0.1','::1'); \
		FLUSH PRIVILEGES;"
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}Shutdown mysql${RESET}"
	#service mysql stop
	mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
	echo -e "${GREEN}DONE${RESET}"
fi

echo -e "${B_BLUE}start with 'exec mysqld_safe'${RESET}"
exec mysqld_safe

