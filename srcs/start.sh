#!/bin/bash

########### phpmyadmin #############
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -zxvf phpMyAdmin-4.9.0.1-all-languages.tar.gz 
mv phpMyAdmin-4.9.0.1-all-languages /var/www/phpmyadmin
rm phpMyAdmin-4.9.0.1-all-languages.tar.gz

########### wordpress ##############
wget https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
mv latest wordpress
mv wordpress /var/www/
rm latest.tar.gz

########### config nginx ###########
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

########### vhost nginx ############
cat /srcs/default > /etc/nginx/sites-available/default

########### ssl ####################
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

########### mysql ##################
service mysql start
mysql -u root < /srcs/create_database.sql

service mysql restart && service php7.3-fpm restart && service nginx restart 
/bin/sh