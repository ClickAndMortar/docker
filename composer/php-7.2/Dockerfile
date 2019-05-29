FROM php:7.2-cli

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git wget zip \
    && wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && rm -rf /var/lib/apt/lists \
    && echo 'memory_limit = 1024M' > /usr/local/etc/php/conf.d/99-custom.ini

WORKDIR /app
