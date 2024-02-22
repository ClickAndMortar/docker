FROM php:7.4-apache-buster

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git wget zip zlib1g-dev libicu-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libzip-dev libmagickwand-dev \
    && wget -q https://getcomposer.org/composer-1.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && docker-php-ext-install pdo pdo_mysql opcache zip json \
    && pecl install apcu imagick \
    && docker-php-ext-enable apcu imagick \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
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
