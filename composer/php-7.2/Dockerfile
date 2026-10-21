FROM php:7.2-cli

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

# Composer épinglé et vérifié : SHA-256 recoupée entre getcomposer.org et la release GitHub (et sa signature GPG).
# Même ligne que ce que l'URL servait aujourd'hui (composer.phar = dernière stable).
ARG COMPOSER_VERSION=2.10.3
ARG COMPOSER_SHA256=7a2d379d5b8ffdaa028580ef26494c36d2feef4b178d3dd1473a4dbc5e17c8d6

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git wget zip \
    && wget -q https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -O /usr/local/bin/composer \
    && echo "${COMPOSER_SHA256}  /usr/local/bin/composer" | sha256sum -c - \
    && chmod +x /usr/local/bin/composer \
    && rm -rf /var/lib/apt/lists \
    && echo 'memory_limit = 1024M' > /usr/local/etc/php/conf.d/99-custom.ini

WORKDIR /app
