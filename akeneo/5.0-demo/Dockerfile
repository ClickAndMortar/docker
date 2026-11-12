FROM php:7.4-apache AS php-builder

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

ARG VERSION=5.0

# Composer épinglé et vérifié : SHA-256 recoupée entre getcomposer.org et la release GitHub (et sa signature GPG).
# Même ligne que ce que l'URL servait aujourd'hui (composer-2.phar).
ARG COMPOSER_VERSION=2.10.3
ARG COMPOSER_SHA256=7a2d379d5b8ffdaa028580ef26494c36d2feef4b178d3dd1473a4dbc5e17c8d6

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git wget zip zlib1g-dev libicu-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev libmagickwand-dev libzip-dev \
    && wget -q https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/local/bin/composer \
    && echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum -c - \
    && chmod +x /usr/local/bin/composer

COPY pim-init-db.sh /usr/local/bin/pim-init-db.sh
COPY php.ini /usr/local/etc/php/conf.d/custom.ini
COPY apache-vhost.conf /etc/apache2/sites-available/000-default.conf

RUN pecl install imagick apcu redis \
    && docker-php-ext-enable imagick redis apcu \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl pdo_mysql bcmath zip exif opcache \
    && a2enmod rewrite \
    && wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/pim-init-db.sh

WORKDIR /app

ENV COMPOSER_MEMORY_LIMIT=4G

RUN composer create-project \
    --no-interaction --ignore-platform-reqs --prefer-dist --no-dev --no-progress \
        akeneo/pim-community-standard . "${VERSION}.*@stable" \
    && composer require league/flysystem-aws-s3-v3:^1.0

RUN bin/console --env=prod pim:installer:assets --clean \
    && bin/console pim:installer:dump-require-paths --env=prod

# NodeJS
FROM node:12 AS js-builder

WORKDIR /app

COPY --from=php-builder /app /app

RUN PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1 yarn install \
    && yarn --cwd=vendor/akeneo/pim-community-dev/akeneo-design-system install --frozen-lockfile

RUN yarn --cwd=vendor/akeneo/pim-community-dev/akeneo-design-system run lib:build \
    && rm -rf public/dist \
    && yarn run webpack \
    && rm -rf public/css \
    && yarn run less \
    && yarn run update-extensions \
    && rm -rf node_modules

# Apache + mod_php server
FROM php-builder as php-prod

COPY --from=js-builder /app /app

WORKDIR /app

RUN rm -rf var/* \
    && mkdir -p public/media \
    && chown www-data:www-data var public/media
