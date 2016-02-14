# Presentation

Debian Jessie based Apache2 and PHP Docker

## Exposed ports

* `80` (HTTP)
* `443` (HTTPS)

## Volumes

* `/var/www/html`

# Build

```bash
make
```

# Run

```bash
docker run -d -P -v $PWD:/var/www/html clickandmortar/apache-php --name=<my_container>
````
