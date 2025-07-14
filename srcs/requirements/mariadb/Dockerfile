FROM debian:bullseye

RUN apt-get update && apt-get install mariadb-server -y

# Create runtime directory for mariadb
RUN mkdir -p /run/mysqld
RUN chown mysql:mysql /run/mysqld

COPY ./conf/setup.sh .
RUN  chmod +x setup.sh

EXPOSE	3306

ENTRYPOINT ["sh", "/setup.sh"]
