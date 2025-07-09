FROM	debian:bullseye

RUN		apt-get update && apt-get install mariadb-server -y

RUN		mariadb-install-db --user=mysql --datadir=/var/lib/mysql

RUN		mkdir -p /run/mysqld
	
RUN 	chown mysql:mysql /run/mysqld
RUN 	chown -R mysql:mysql /var/lib/mysql

COPY setup.sh .

EXPOSE	3306

ENTRYPOINT ["sh", "/setup.sh"]
