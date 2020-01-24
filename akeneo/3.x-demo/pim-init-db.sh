#!/bin/bash

set -e

# Wait for MySQL to be ready
/usr/local/bin/wait-for-it.sh mysql-service:3306 -t 60

# Wait for Elasticsearch to be ready
/usr/local/bin/wait-for-it.sh elasticsearch-service:9200 -t 60

# Init Akeneo database
php -dmemory_limit=-1 /app/bin/console pim:installer:db --env=prod
