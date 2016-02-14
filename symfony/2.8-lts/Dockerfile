FROM clickandmortar/apache-php

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update && apt-get install --no-install-recommends -y \
    apache2 \
    ca-certificates \
    curl \
    git \
    libapache2-mod-php5 \
    mysql-client \
    netcat \
    openssh-client \
    php-apc \
    php5 \
    php5-cli \
    php5-curl \
    php5-gd \
    php5-intl \
    php5-mcrypt \
    php5-mysql \
    php5-xdebug \
    supervisor \
    tar \
    vim \
    wget \
    && apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/*

# Supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start
ADD entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
