# config.sh mariadb
# Colors
B_RED="\033[1;31m"

GREEN="\033[32m"
UL_GREEN="\033[4;32m"
B_GREEN="\033[1;32m"

ORANGE="\033[38;5;166m"
UL_ORANGE="\033[4;38;5;166m"
B_ORANGE="\033[1;38;5;166m"

YELLOW="\033[33m"
UL_YELLOW="\033[4;33m"
B_YELLOW="\033[1;33m"

BLUE="\033[34m"
UL_BLUE="\0334;[34m"
B_BLUE="\033[1;34m"

CYAN="\033[36m"
UL_CYAN="\033[4;36m"
B_CYAN="\033[1;36m"

RESET="\033[0m"

echo -e "${B_GREEN}################ Starting script 'mariadb_config.sh' ###########################################################${RESET}"

if [ -d "/run/mysqld" ]; then
	echo -e "${B_BLUE}/run/mysqld already exist${RESET}"
else
	echo -e "${B_BLUE}Creating '/run/mysqld'${RESET}"
	mkdir -p "/run/mysqld"
	echo -e "${GREEN}DONE${RESET}"
	chown mysql:mysql /run/mysqld
	echo -e "${B_BLUE}all rights given to /run/mysqld'${RESET}"
fi



if [ -d "/var/lib/mysql/mariadb" ]; then
  echo -e "${B_BLUE}Database already exists.${RESET}"
else
  echo -e "${B_BLUE}Creating database.${RESET}"
	echo -e "${B_BLUE}Starting mysql${RESET}"
	service mysql start
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}mysql configuration${RESET}"
	mysql -e "CREATE DATABASE \`$MYSQL_HOSTNAME\`; \
		CREATE USER \`$MYSQL_USER\`@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
		GRANT ALL PRIVILEGES ON \`$MYSQL_HOSTNAME\`.* TO \`$MYSQL_USER\`@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
		ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; \
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION; \
		FLUSH PRIVILEGES;"
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}Modify 50-server.cnf${RESET}"
	sed -i'' '/bind-address/ s/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
	echo -e "${GREEN}DONE${RESET}"
	echo -e "${B_BLUE}Shutdown mysql${RESET}"
	mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
	echo -e "${GREEN}DONE${RESET}"
fi

echo -e "${B_BLUE}start with 'exec mysqld_safe'${RESET}"
exec mysqld_safe

