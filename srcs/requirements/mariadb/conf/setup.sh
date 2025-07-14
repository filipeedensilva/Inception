#!/bin/sh

CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"

echo "[mariadb:setup.sh] Started!"

if grep -q "^\s*bind-address" "$CONFIG_FILE"; then
        sed -i "s/^\s*bind-address\s*=.*/bind-address = 0.0.0.0/" "$CONFIG_FILE"
fi

if [ -d "/var/lib/mysql/$DB_NAME" ]; then
	echo "[mariadb:setup.sh] Database '$DB_NAME' already exists!" 
else
	echo "[mariadb:setup.sh] Database '$DB_NAME' doesn't exist, creating it now!"
	mysql_install_db --user=mysql --ldata=/var/lib/mysql
	mysqld_safe --user=mysql --datadir=/var/lib/mysql &
	sleep 3
	mysql -u root <<EOF
	CREATE DATABASE IF NOT EXISTS $DB_NAME;
	CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_USER_PASSWORD';
	GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
EOF
	mysqladmin -uroot -p$DB_ROOT_PASSWORD shutdown
	sleep 2
fi
exec mysqld_safe --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
