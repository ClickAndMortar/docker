#!/bin/bash
set -e

if [ -f /var/www/app/console ]; then
    echo "Initialize Symfony2"

    cd /var/www
    setfacl -R -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs || true
    setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs || true

    if grep -wq mysql /etc/hosts; then

        echo -n "waiting for TCP connection to mysql:3306..."

         # Ugly : waiting for mysql db restart
        if [ -n "$MYSQL_1_ENV_DOMAIN_NAME" ]; then
            ping $MYSQL_1_ENV_DOMAIN_NAME --c=6
            while ! nc -w 1 $MYSQL_1_ENV_DOMAIN_NAME 3306 2>/dev/null
            do
              echo -n .
              sleep 1
            done
        fi

        if [ -d /var/www/app/DoctrineMigrations ]; then
            php app/console doctrine:migrations:migrate --no-interaction || true
        else
            php app/console doctrine:schema:update --dump-sql --force || true
        fi
    fi
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
