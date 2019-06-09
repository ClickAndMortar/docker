FROM php:7.2-cli

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y lua5.3 liblua5.3 liblua5.3-dev \
    && cp /usr/include/lua5.3/lua.h /usr/include \
    && ln -s /usr/include/lua*.*/ /usr/include/lua \
    && cp /usr/lib/x86_64-linux-gnu/liblua5.3.a /usr/lib/liblua.a \
    && cp /usr/lib/x86_64-linux-gnu/liblua5.3.so /usr/lib/liblua.so \
    && pecl install lua \
    && docker-php-ext-enable lua
