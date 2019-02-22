# Magento Docker

Debian Stretch based Docker image for Magento 2.3 website development containing PHP 7.2, Apache 2 and [Composer](https://getcomposer.org/).

## Usage

Create a `docker-compose.yml` file in your Magento project's root, using the sample below:

```yml
php:
  image: clickandmortar/magento:2.3
  ports:
  - 2380:8080
  volumes:
  - ./magento:/app

mysql:
  image: mysql:5.7
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: magento
    MYSQL_USER: magento
    MYSQL_PASSWORD: magento
```

Then run it : `docker-compose up -d`.

### Magento install

First [get your authentication keys](https://devdocs.magento.com/guides/v2.3/install-gde/prereq/connect-auth.html) for Magento repository, then:

```bash
docker-compose exec php composer create-project --repository=https://repo.magento.com/ magento/project-community-edition magento
```

You may run the setup wizard from the web UI at http://localhost:2380, or run it via CLI:

```bash
docker-compose exec php bin/magento setup:install \
                        --base-url=http://localhost:2380 \
                        --db-host=mysql \
                        --db-name=magento \
                        --db-user=magento \
                        --db-password=magento \
                        --backend-frontname=admin \
                        --admin-firstname=admin \
                        --admin-lastname=admin \
                        --admin-email=admin@admin.com \
                        --admin-user=admin \
                        --admin-password=magent0 \
                        --language=en_GB \
                        --currency=EUR \
                        --timezone=Europe/Paris \
                        --use-rewrites=1
```
