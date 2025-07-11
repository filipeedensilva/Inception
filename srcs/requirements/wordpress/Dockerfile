FROM	debian:bullseye

RUN	apt-get update && \
	apt-get install php-fpm php-mysql wget unzip curl -y

RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

WORKDIR	/var/www/wordpress

RUN	rm -rf /var/www/html/*

RUN	wget http://wordpress.org/latest.tar.gz && \
	tar xfz latest.tar.gz && \
	rm -rf latest.tar.gz

RUN	mv wordpress/*

RUN	chown -R www-data:www-data /var/www/wordpress

RUN	rm -rf wordpress

COPY	./conf/wp-config.php /var/www/html/wp-config.php
COPY	./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY	setup.sh ~
RUN	chmod +x ~/setup.sh

EXPOSE	9000

ENTRYPOINT [ "bash", "~/setup.sh" ]
