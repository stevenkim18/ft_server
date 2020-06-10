FROM debian:buster

WORKDIR /home

RUN apt-get update
RUN apt-get -y upgrade

# openssl
RUN apt-get install -y openssl
RUN openssl req -x509 -days 90 \
    -out /etc/ssl/certs/localhost.crt \
    -keyout /etc/ssl/certs/localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' \
 && chmod 600 /etc/ssl/certs/localhost.key \
 && chmod 600 /etc/ssl/certs/localhost.crt

# nginx
RUN apt-get -y install nginx
RUN mv /var/www/html/index.nginx-debian.html /var/www/html/nginx.html

# php
RUN apt-get -y install php-fpm php-mbstring php-curl

COPY srcs/phpinfo.php /var/www/html
COPY srcs/default /etc/nginx/sites-available/

# mariadb
RUN apt-get install -y php-mysql mariadb-server
COPY srcs/db.sql /home
RUN service mysql start && mysql -u root < db.sql 

# phpMyAdmin
COPY srcs/phpMyAdmin-4.9.5-all-languages.tar.gz /home
RUN tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.5-all-languages/ phpmyadmin
RUN mv phpmyadmin/ /usr/share/
COPY srcs/config.inc.php /usr/share/phpmyadmin
RUN mkdir /usr/share/phpmyadmin/tmp && chgrp www-data /usr/share/phpmyadmin/tmp && chmod 774 /usr/share/phpmyadmin/tmp
RUN ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# wordpress
COPY srcs/wordpress-5.4.1.tar.gz /home
RUN tar -zxvf wordpress-5.4.1.tar.gz
RUN rm wordpress-5.4.1.tar.gz
RUN mv ./wordpress /var/www/html/

COPY srcs/wp-config.php /var/www/html/wordpress/

COPY srcs/start_services.sh /home/

EXPOSE 80 443
