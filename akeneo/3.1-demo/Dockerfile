FROM php:7.2-cli AS php-builder

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git wget zip \
    && wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

WORKDIR /app

RUN composer global require hirak/prestissimo \
    && php -dmemory_limit=-1 /usr/local/bin/composer create-project --no-interaction --ignore-platform-reqs --prefer-dist --no-dev --no-progress \
        akeneo/pim-community-standard . "3.1.*@stable" \
    && rm -rf /app/var/*

COPY parameters.yml /app/app/config/parameters.yml

# NodeJS
FROM node:10 AS js-builder

WORKDIR /app

COPY --from=php-builder /app /app

RUN yarn install && yarn run webpack && rm -rf node_modules

# PHP Apache server
FROM php:7.2-apache

COPY --from=js-builder /app /app

COPY pim-init-db.sh /usr/local/bin/pim-init-db.sh

ENV APACHE_RUN_USER docker

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git wget zip zlib1g-dev libicu-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libmagickwand-dev \
    && wget https://getcomposer.org/composer.phar -O /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && docker-php-ext-install pdo pdo_mysql opcache zip bcmath exif \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && a2enmod rewrite \
    && sed -i 's/Listen 80$/Listen 8080/g' /etc/apache2/ports.conf \
    && wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/pim-init-db.sh

COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

RUN useradd -s /bin/bash -d /home/docker -m -g www-data docker \
    && mkdir -p /app \
    && chown -R docker /app

WORKDIR /app

USER docker

EXPOSE 8080
