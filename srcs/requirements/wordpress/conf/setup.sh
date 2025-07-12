#!/bin/sh

echo "Setting up Wordpress..."
until mysqladmin ping -h "$DB_HOST" -p "$DB_PORT" --silent; do
	echo "Waiting for mariadb..."
    sleep 1
done

sleep 5

if ! wp core is-installed --allow-root 2> /dev/null; then
	echo "Wordpress is not installed. Installing now ..."
	wp core download --allow-root
		sleep 3
	wp config create --allow-root \
		--dbname="$DB_NAME" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_USER_PASSWORD" \
		--dbhost="$DB_PORT"
	wp core install --allow-root \
		--url="$DOMAIN" \
		--title="Inception" \
		--admin_user="$ADMIN_USER" \
		--admin_password="$ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL" \
		--skip-email

	chown -R www-data:www-data /var/www/html/wp-content

	wp user create --allow-root "$WP_USER" "$WP_EMAIL" --user_pas="$WP_PASSWORD"
else
	echo "WordPress is already installed! Running..."
fi

exec php-fpm -F -R
