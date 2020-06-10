FROM debian:buster

WORKDIR /home

RUN apt-get update
RUN apt-get -y upgrade

# nginx
RUN apt-get -y install nginx

# php
RUN apt-get -y install php-fpm
RUN apt-get -y install php-mbstring
RUN apt-get -y install php-curl

COPY srcs/phpinfo.php /var/www/html
COPY srcs/default /etc/nginx/sites-available/

# mariadb
RUN apt-get install -y php-mysql
RUN apt-get install -y mariadb-server
COPY srcs/db.sql /home
RUN mysql -u root -p < db.sql 

# phpMyAdmin
COPY srcs/phpMyAdmin-4.9.5-all-languages.tar.gz /home
RUN tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.5-all-languages/ phpmyadmin
RUN mv phpmyadmin/ /usr/share/
COPY srcs/config.inc.php /usr/share/phpmyadmin
RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

COPY srcs/start_services.sh /home/

EXPOSE 80
