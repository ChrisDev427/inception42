# Dockerfile mariadb

FROM debian:buster

RUN apt update && apt install -y mariadb-server mariadb-client

COPY tools/mariadb_config.sh /etc/mariadb_config.sh

RUN chmod +x /etc/mariadb_config.sh

EXPOSE 3306

ENTRYPOINT ["bash", "/etc/mariadb_config.sh"]
