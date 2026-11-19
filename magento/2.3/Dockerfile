FROM php:7.2-apache-stretch

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

# Composer épinglé et vérifié : SHA-256 recoupée entre getcomposer.org et la release GitHub (la ligne 1.x n'est pas signée).
# Reste en Composer 1, comme l'exige le projet (Magento 2.3 avant 2.3.7 ne supporte que Composer 1).
ARG COMPOSER_VERSION=1.10.28
ARG COMPOSER_SHA256=0915af36eb01e3f0e16cd309adff7051832b9ef014e38371756804b20425cd5a

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git wget zip zlib1g-dev libicu-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libxslt1-dev \
    && wget -q https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/local/bin/composer \
    && echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum -c - \
    && chmod +x /usr/local/bin/composer \
    && docker-php-ext-install pdo pdo_mysql opcache zip json bcmath soap xsl \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && a2enmod rewrite \
    && sed -i 's/Listen 80$/Listen 8080/g' /etc/apache2/ports.conf

COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

RUN useradd -s /bin/bash -d /home/docker -m -g www-data docker

USER docker

WORKDIR /app

EXPOSE 8080
