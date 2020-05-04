FROM debian:buster

ENV USERNAME	'admin'
ENV PASSWORD	'admin'

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update; \ 
	apt-get -y install apt-utils; \
	apt-get -y install dialog apt-utils; \
	apt-get -y install mariadb-server; \
	apt-get -y install debconf lsb-release; \
	apt-get -y install debconf-utils; \
	apt-get -y install wget; \
	apt-get -y install php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline; \
	apt-get -y install php-mysql; \
	apt-get -y install nginx

########### phpmyadmin #############
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz; \
	tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz; \
	mv phpMyAdmin-4.9.0.1-all-languages /var/www/phpmyadmin; \
	rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

########### wordpress ##############
RUN	wget https://wordpress.org/latest.tar.gz; \
	tar xzvf latest.tar.gz; \
	mv wordpress /var/www/; \
	chown -R www-data:www-data /var/www/wordpress; \
	rm latest.tar.gz

########### vhost nginx ############
COPY srcs/default /etc/nginx/sites-available/

########### SSL ###########d
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj '/C=FR/ST=75/L=Paris/O=42/CN=lulebugl' \
	-keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

RUN mkdir src
COPY ./srcs/* /src/

CMD	service mysql start; \
	service nginx start; \
	service php7.3-fpm start; \
	mysql -u root -p$PASSWORD -e "CREATE USER '$USERNAME'@'localhost' identified by '$PASSWORD';" ;\
	mysql -u root -p$PASSWORD -e "CREATE DATABASE wordpress;"; \
	mysql -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON wordpress.* TO '$USERNAME'@'localhost';" ;\
	mysql -u root -p$PASSWORD -e "FLUSH PRIVILEGES;"; \
	sleep infinity & wait

EXPOSE 8080 80 443 3306 33060