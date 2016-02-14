# Symfony Development Docker

Docker image for Symfony2 website development containing PHP 5.6, Apache2, APC, [Composer](https://getcomposer.org/) and xDebug.

## Usage

Create a `docker-compose.yml` file in your Symfony project's root, using the sample below:

```yml
app:
  image: clickandmortar/symfony
  links:
    - mysql:mysql.project.docker
  ports:
    - "12080:80"
  volumes_from:
    - volumecache
  volumes:
    - ./:/var/www
    - /var/www/app/cache
    - /var/www/app/logs
  environment:
    DOMAIN_NAME: app.project.docker
    SYMFONY_ENV: dev
    SYMFONY_DEBUG: 1
    SYMFONY_HIDE_DEPRECATED: true

mysql:
  image: mysql:5.6
  ports:
    - "12306:3306"
  environment:
    DOMAIN_NAME: mysql.project.docker
    MYSQL_DATABASE: project
    MYSQL_ROOT_PASSWORD: root

volumecache:
  image: busybox
  volumes:
    - ~/.composer:/root/.composer
```

Then run it : `docker-compose up -d`.

You can check the running containers with the `docker-compose ps` command.

## Credits

Special thanks to Michel ROCA (@mroca) for his very inspiring work.
