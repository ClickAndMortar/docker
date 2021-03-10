#!/bin/bash

set -e

# Wait for MySQL to be ready
/usr/local/bin/wait-for-it.sh ${APP_DATABASE_HOST}:${APP_DATABASE_PORT} -t 60

# Wait for Elasticsearch to be ready
/usr/local/bin/wait-for-it.sh ${APP_INDEX_HOSTS} -t 60

# Init Akeneo database
echo "Installing Akeneo database"
php -dmemory_limit=4G /app/bin/console pim:installer:db --catalog vendor/akeneo/pim-community-dev/src/Akeneo/Platform/Bundle/InstallerBundle/Resources/fixtures/minimal

# Create admin user
echo "Creating Akeneo admin user"
php -dmemory_limit=4G /app/bin/console pim:user:create ${AKENEO_ADMIN_USERNAME:=admin} ${AKENEO_ADMIN_PASSWORD:=admin} ${AKENEO_ADMIN_EMAIL:=admin@example.com} Admin Admin en_US --admin -n
