The Inception42 project involves creating a virtual infrastructure using Docker, with separate containers for NGINX, WordPress, and MariaDB.
The containers are built from Alpine or Debian images.
Two volumes are used for the WordPress database and site files.
A Docker network connects the containers, and they automatically restart in case of failure.
The WordPress database must include two users.
The project focuses on the configuration and deployment of these services within the Docker infrastructure.
