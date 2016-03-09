# Apache PHP Docker

Debian Jessie based Apache2 and PHP Docker image.

## Exposed ports

* `80` (HTTP)

## Volumes

* `/var/www`

# Build

```bash
make
```

# Run

```bash
docker run -d -P -v $PWD:/var/www clickandmortar/apache-php --name=<my_container>
````
