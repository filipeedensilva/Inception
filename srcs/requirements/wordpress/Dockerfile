FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    gnupg2 && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    wget -qO - https://packages.sury.org/php/apt.gpg | apt-key add -

RUN	apt-get update && apt-get install -y \
	php8.3 \
    php8.3-cli \
    php8.3-fpm \
    php8.3-mysqli \
    php8.3-curl \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-gd \
    php8.3-zip \
    php8.3-opcache \
    php8.3-common \
    php8.3-dom \
    php8.3-intl \
    php8.3-readline \
	unzip \
	curl \
	mariadb-client

RUN update-alternatives --install /usr/bin/php php /usr/bin/php8.3 83

RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

WORKDIR	/var/www/html

RUN mkdir -p /run/php

COPY ./conf/www.conf /etc/php/8.3/fpm/pool.d/www.conf
COPY ./conf/setup.sh /
RUN  chmod +x /setup.sh

EXPOSE	9000

ENTRYPOINT [ "sh", "/setup.sh" ]
