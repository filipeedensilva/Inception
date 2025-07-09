#!/bin/sh

echo "[mariadb:setup.sh] Started!"

if [ -d "/var/lib/mysql/$MYSQL_DATABASE"]; then
	echo "[mariadb:setup.sh] Database '$MYSQL_DATABASE' already exists!" 
	if ! grep -q "#skip-networking" "/etc/my.cnf.d/mariadb-server.cnf"; then
		sed -i "s/skip-networking/#skip-networking/" /etc/my.cnf.d/mariadb-server.cnf
		sed -i "s/#bind-address=0.0.0.0/bind-address=0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf
	fi
	if ! grep -q "socket=/run/mysqld/mysqld.sock" "/etc/my.cnf.d/mariadb-server.cnf"; then
		sed -i "s/\[mysqld\]/&\nsocket=\/run\/mysqld\/mysqld.sock/" /etc/my.cnf.d/mariadb-server.cnf
fi
else
	echo "[mariadb:setup.sh] Database '$MYSQL_DATABASE' doesn't exist, creating it now!"
	mysql_install_db --user=mysql --ldata=/var/lib/mysql
	sed -i "s/skip-networking/#skip-networking/" /etc/my.cnf.d/mariadb-server.cnf
	sed -i "s/#bind-address=0.0.0.0/bind-address=0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf	
	mysqld --user=mysql --datadir=/var/lib/mysql &
	sleep 3
	mysql -uroot -e "CREATE DATABASE $MYSQL_DATABASE;"
	mysql -uroot -e "CREATE USER IF NOT EXISTS $MYSQL_USER IDENTIFIED BY '$MYSQL_USER_PASSWORD';"
	mysql -uroot -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO $MYSQL_USER@'%';"
	mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
	mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
	mysqladmin -uroot -p$MYSQL_ROOT_PASSWORD shutdown
	sleep 2
fi
exec mysqld --user=mysql --datadir=/var/lib/mysql
