# Symfony Docker

Debian Stretch based Docker image for Symfony 4.x website development containing PHP 7.2, Apache 2 and [Composer](https://getcomposer.org/).

## Usage

Create a `docker-compose.yml` file in your Symfony project's root, using the sample below:

```yml
php:
  image: clickandmortar/symfony:4.x
  ports:
  - 12080:8080
  volumes:
  - .:/app
  environment:
    APP_ENV: dev
    APACHE_RUN_USER: docker

mysql:
  image: mysql:5.7
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: project
```

Then run it : `docker-compose up -d`.

You can check the running containers with the `docker-compose ps` command.
