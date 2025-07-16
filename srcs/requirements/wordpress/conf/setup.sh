#!/bin/sh

echo "Setting up Wordpress..."
until mysqladmin ping -h"mariadb" -P"3306" --silent; do
    echo "Waiting for mariadb to be set up..."
    sleep 1
done

sleep 5

if ! wp core is-installed --allow-root 2> /dev/null; then
	echo "Wordpress is not installed. Installing now ..."
	rm -rf /var/www/html/*
	wp core download --allow-root
		sleep 3
	wp config create --allow-root \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_USER_PASSWORD" \
		--dbhost="$DB_HOST"
	echo "User created!\nStarting to do wp core install"
	wp core install --allow-root \
		--url="$DOMAIN" \
		--title="Inception" \
		--admin_user="$ADMIN_USER" \
		--admin_password="$ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL" \
		--skip-email
	echo "Wp core installed!"

	chown -R www-data:www-data /var/www/html/wp-content

	wp user create "$WP_USER" "$WP_EMAIL" --user_pass="$WP_PASSWORD" --role=author --allow-root
	wp theme install "$WP_THEME" --activate --allow-root
else
	echo "WordPress is already installed! Running..."
fi

echo "Executing php-fpm8.3"
exec php-fpm8.3 -F -R
