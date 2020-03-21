FROM debian:buster
MAINTAINER lulebugl@student.42.fr
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
&& apt-get -y upgrade \ 
&& apt-get -y install apt-utils \
&& apt-get -y install dialog apt-utils \
&& apt-get -y install mariadb-server \
&& apt-get -y install wget \
&& apt-get -y install php7.3 php7.3-fpm php7.3-mysql php-common php7.3-cli php7.3-common php7.3-json php7.3-opcache php7.3-readline \
&& apt-get -y install php-mysql \
&& apt-get -y install nginx		\
&& apt-get clean

RUN service nginx start && service mysql start && service php7.3-fpm start

RUN mkdir srcs
COPY ./srcs/* /srcs/

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/srcs/start.sh"]