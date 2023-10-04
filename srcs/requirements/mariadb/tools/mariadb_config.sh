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

echo "Starting mysql"
service mysql start
echo "DONE"

echo "Create database if not exist"
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_HOSTNAME}\`;"
echo "DONE"

echo "Create user if not exist"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
echo "DONE"

echo "Grant all previleges on $MYSQL_HOSTNAME to $MYSQL_USER identified by $MYSQL_USER_PASSWORD"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_HOSTNAME}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';"
echo "DONE"

echo "Setting root password $MYSQL_ROOT_PASSWORD"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
echo "DONE"

echo "Refresh privileges"
mysql -e "FLUSH PRIVILEGES;"
echo "DONE"

echo "Shutdown mysql"
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
echo "DONE"




echo "Restart mysql"
exec mysqld_safe
echo "DONE"


