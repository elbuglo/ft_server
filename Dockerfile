FROM debian:buster

ENV USERNAME	'admin'
ENV PASSWORD	'admin'

# Possible values: 'on' or 'off'
ARG NGINX_AUTO_INDEX="on"
ARG MYSQL_PASSWORD="password"
ARG DATABASE_NAME=wordpress

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update; \ 
	apt-get -y install apt-utils dialog apt-utils; \
	apt-get -y install mariadb-server debconf lsb-release debconf-utils; \
	apt-get -y install wget vim; \
	apt-get -y install default-mysql-server; \
	apt-get -y install php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline php-mysql; \
	apt-get -y install nginx

########### phpmyadmin #############
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz; \
	tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz; \
	mv phpMyAdmin-4.9.0.1-all-languages /var/www/phpmyadmin; \
	rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

########### wordpress ##############
##COPY ./srcs/wp-config.php wp-config.php
RUN	wget https://wordpress.org/latest.tar.gz; \
	tar xzvf latest.tar.gz; \
	mv wordpress /var/www/; \
	chown -R www-data:www-data /var/www/wordpress; \
	rm latest.tar.gz; 
	# sed -i 's/%MYSQL_PASSWORD%/'$MYSQL_PASSWORD'/g' wp-config.php ; \
	# sed -i 's/%MYSQL_DATABASE%/'$DATABASE_NAME'/g' wp-config.php

########### vhost nginx ############
COPY srcs/default /etc/nginx/sites-available/

########## AUTO_INDEX on or off ############
RUN	 sed -i 's/%AUTO_INDEX%/'$NGINX_AUTO_INDEX'/g' /etc/nginx/sites-available/default ;

########### SSL ###########d
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj '/C=FR/ST=75/L=Paris/O=42/CN=lulebugl' \
	-keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

# RUN service mysql start; \
# 	mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS "$DATABASE_NAME";" ; \
# 	mysqladmin -u root -p password $MYSQL_PASSWORD

EXPOSE 80 443

CMD	service mysql start; \
	service php7.3-fpm start; \
	mysql -u root -p$PASSWORD -e "CREATE USER '$USERNAME'@'localhost' identified by '$PASSWORD';" ;\
	mysql -u root -p$PASSWORD -e "CREATE DATABASE wordpress;"; \
	mysql -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$USERNAME'@'localhost';" ;\
	mysql -u root -p$PASSWORD -e "FLUSH PRIVILEGES;"; \
	nginx -g 'daemon off;'

