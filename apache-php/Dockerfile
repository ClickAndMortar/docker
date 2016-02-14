FROM debian:jessie

# Heavily inspired by CenturyLinkLabs Dockerfiles
MAINTAINER  Click & Mortar <contact@clickandmortar.fr>

ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
 apt-get -y install ca-certificates curl git netcat supervisor tar vim wget && \
 apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-intl php5-mcrypt php5-gd php-pear php-apc php5-apcu php5-xsl php5-cli php5-curl && \
 apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/* && \
 curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# PHP configuration
 RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/{apache2,cli}/php.ini && \
     sed -i -e  's/post_max_size = 8M/post_max_size = 16M/g' \
     -e 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' \
     -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g' \
     -e 's/display_errors = Off/display_errors = On/'
     -e "s/max_execution_time = 30/max_execution_time = 300/" \
     -e "s/max_input_time = 60/max_input_time = 300/" \
     -e "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php5/apache2/php.ini

# Override default Apache conf
ADD apache-vhost.conf /etc/apache2/sites-available/000-default.conf
ADD apache-vhost-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Enable Apache rewrite & ssl modules
RUN a2enmod rewrite ssl

# Enable SSL VirtualHost
RUN a2ensite default-ssl

# Add image configuration and scripts
ADD apache2.sh /apache2.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /*.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# Expose HTTP and HTTPS
EXPOSE 80 443

# Share Apache DocumentRoot
VOLUME ["/var/www/html"]

WORKDIR /var/www/html

CMD ["/entrypoint.sh"]
