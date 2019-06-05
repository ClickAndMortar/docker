# Akeneo 3.1 Demo

This repo provides the following:

* Fully-packaged Docker for Akeneo 3.1 🐳
* Helm chart to deploy the demo on Kubernetes ☁

Those can be used to easily deploy a working demo of Akeneo 3.1 🚀.

## Usage

### With Kubernetes, using Helm

#### Without Ingress

```bash
helm install helm/chart/ --name=akeneo-demo
```

Then run:

```bash
kubectl -n akeneo port-forward svc/akeneo 8080
```

Open http://localhost:8080 and login with `admin` / `admin`.

#### With an Ingress

```bash
helm install helm/chart/ --name=akeneo-demo --set akeneo.ingress=true --set akeneo.hostname=my.host.name
```

See `helm/chart/values.yaml` for default & available config values.

---

Once you're done giving Akeneo a try, you may delete the whole stack:

```bash
helm delete --purge akeneo-demo
```

### With Docker

> _Optional step: build the image running `make build` within this directory._

You may use the following `docker-compose.yml` sample:

```yaml
version: '3'
services:
  php:
    image: clickandmortar/akeneo:3.1-demo
    ports:
    - 3380:8080
    environment:
      SYMFONY_ENV: prod

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

Run `docker-composer exec php /usr/local/bin/pim-init-db.sh` to initialize database, and load demo data.

Then open http://localhost:3380.

## Enhancements

- [x] Automatically run DB installer (`pim:installer:db` command) on deployment: init Job created
- [ ] Use environment variables for config within `parameters.yml`
- [ ] Store passwords in Secrets
- [x] Test scaling up Akeneo deployment: ✅ once DB is initialized
- [x] Run a separate Deployment for the queue consumer
- [ ] Setup Akeneo cron tasks as Kubernetes Jobs
- [x] Remove mandatory use Ingress Controller
