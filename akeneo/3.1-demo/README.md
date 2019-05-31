# Akeneo 3.1 Demo

This repo provides the following:

* Fully-packaged Docker for Akeneo 3.1
* Helm chart to deploy the demo on Kubernetes

## Usage

### With Docker

Build the image running `make build` within this directory.

Then use the following `docker-compose.yml` sample:

```yaml
version: '3'
services:
  php:
    image: clickandmortar/akeneo:3.1-demo
    ports:
    - 3380:8080

  mysql:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: akeneo
      MYSQL_DATABASE: akeneo
      MYSQL_USER: akeneo
      MYSQL_PASSWORD: akeneo
  
  elasticsearch:
    image: elasticsearch:6.5.4
```

Then open http://localhost:3380.

### With Kubernetes

Using Helm:

```yaml
helm install helm/chart/ --name=akeneo-demo --set akeneo.hostname=my.host.name
```

Note that this Helm chart requires a running Ingress controller to work properly.

See `helm/chart/values.yaml` for default & available config values.

## Enhancements

- [ ] Automatically run DB installer (`pim:installer:db` command) on deployment
- [ ] Allow alternate service exposure methods (node port, cluster IP, etc.)
- [ ] Use environment variables for config within `parameters.yml`
- [ ] Test scaling up Akeneo deployment 
