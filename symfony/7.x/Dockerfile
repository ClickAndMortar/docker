FROM php:8.3-apache-bookworm

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git wget zip libfreetype6-dev libicu-dev libjpeg62-turbo-dev libpng-dev libxslt1-dev libzip-dev libwebp-dev libavif-dev \
    && wget -q https://getcomposer.org/download/latest-2.x/composer.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-avif \
    && docker-php-ext-install -j$(nproc) bcmath gd intl pcntl pdo_mysql sockets xsl zip \
    && a2enmod rewrite \
    && sed -i 's/Listen 80$/Listen 8080/g' /etc/apache2/ports.conf

COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

RUN useradd -s /bin/bash -d /home/docker -m -g www-data docker \
    && mkdir /app \
    && chown docker /app

USER docker

WORKDIR /app

EXPOSE 8080
