# ft_server

# Some ressources
  * [MariaDB](https://kifarunix.com/install-lemp-stack-on-debian-10-buster)
  * [Phpmyadmin](https://kifarunix.com/install-phpmyadmin-with-nginx-on-debian-10-buster)
  * [Wordpress](https://kifarunix.com/install-wordpress-5-with-nginx-on-debian-10-buster/)
  * [Dockerfile](https://putaindecode.io/articles/les-dockerfiles/)

# To build image
  docker build -t img_lulebugl .

# To run container
  docker run -tid -p 80:80 -p 443:443 --name test img_lulebgul

# To delete container(first)
  docker rm -f test

# To delete image
  docker rmi img_lulebugl