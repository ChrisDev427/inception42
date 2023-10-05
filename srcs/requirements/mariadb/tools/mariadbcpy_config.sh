# config.sh mariadb

echo "Starting script 'mariadb_config.sh'"

if [ -d "/run/mysqld" ]; then
	echo "/run/mysqld already exist"
else
	echo "Creating '/run/mysqld'"
	mkdir -p "/run/mysqld"
	echo "'/run/mysqld' created"
	chown mysql:mysql /run/mysqld
	echo "all rights given to /run/mysqld'"
fi


echo "Modify 50-server.cnf"
sed -i'' '/bind-address/ s/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
echo "DONE"

echo "Starting mysql"
service mysql start
echo "DONE"

echo "mysql configuration"
mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_HOSTNAME\`; \
	CREATE USER IF NOT EXISTS \`$MYSQL_USER\`@'localhost' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
	GRANT ALL PRIVILEGES ON \`$MYSQL_HOSTNAME\`.* TO \`$MYSQL_USER\`@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD'; \
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; \
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION; \
	FLUSH PRIVILEGES;"
	
echo "DONE"

echo "Shutdown mysql"
mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
echo "DONE"

echo "Restart mysql"
exec mysqld_safe
echo "DONE"

