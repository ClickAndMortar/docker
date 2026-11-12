FROM debian:jessie

# Heavily inspired by CenturyLinkLabs Dockerfiles
MAINTAINER  Click & Mortar <contact@clickandmortar.fr>

# Composer épinglé et vérifié : SHA-256 recoupée entre getcomposer.org et la release GitHub (et sa signature GPG).
# 2.2 LTS : la seule ligne de Composer 2 compatible avec PHP 5.6 de Debian jessie.
ARG COMPOSER_VERSION=2.2.30
ARG COMPOSER_SHA256=8c2b4478b64f8f7cdf1574838fdb0033b29049ca821dad452db7a3dcfcdbffc2

# Install packages
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get update && \
 LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install ca-certificates curl git netcat supervisor tar vim wget && \
 LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-intl php5-mcrypt php5-gd php-pear php-apc php5-apcu php5-xsl php5-cli php5-curl && \
 LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/* && \
 curl -fsSL https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/local/bin/composer && \
 echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum -c - && \
 chmod +x /usr/local/bin/composer

# PHP configuration
 RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/apache2/php.ini /etc/php5/cli/php.ini && \
     sed -i -e  's/post_max_size = 8M/post_max_size = 16M/g' \
     -e 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' \
     -e 's/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g' \
     -e 's/display_errors = Off/display_errors = On/' \
     -e "s/max_execution_time = 30/max_execution_time = 300/" \
     -e "s/max_input_time = 60/max_input_time = 300/" \
     -e "s/memory_limit = 128M/memory_limit = 1024M/" /etc/php5/apache2/php.ini

# Override default Apache conf
ADD apache-vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache rewrite & ssl modules
RUN a2enmod rewrite

# Add image configuration and scripts
ADD apache2.sh /apache2.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /*.sh
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# Expose HTTP
EXPOSE 80

# Share Apache DocumentRoot
VOLUME ["/var/www"]

WORKDIR /var/www

CMD ["/entrypoint.sh"]
