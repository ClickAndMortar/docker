# Akeneo 3.x Demo

This repo provides the following:

* Fully-packaged Docker for Akeneo 3.x 🐳 (3.1 & 3.2 currently available)
* Helm chart to deploy the demo on Kubernetes ☁

Those can be used to easily deploy a working demo of Akeneo 3.x 🚀.

## Usage

### With Kubernetes, using Helm

Available configuration values:

| Name | Default | Info |
|---|---|---|
| `akeneo.version` | `3.2` | Version to install / use (must be >= 3.1) |
| `akeneo.image` | none | Custom Docker image to use (must listen for HTTP) |
| `akeneo.replicas` | `1` | Number of Akeneo instances |
| `akeneo.ingress.enabled` | `false` | Enable use of Ingress |
| `akeneo.ingress.hostname` | none | Hostname for Ingress |
| `akeneo.ingress.https` | `false` | Enable HTTPS for Ingress |
| `akeneo.ingress.certmanagerClusterIssuer` | none | Cert Manager Cluster Issuer name |
| `akeneo.port` | `8080` | HTTP port the image is listening on |
| `mysql.image` | `mysql:5.7` | MySQL image to use |
| `mysql.storage.size` | `20Gi` | Size of MySQL Persistent Volume |
| `mysql.storage.class` | `standard` | Storage Class of MySQL PV |
| `elasticsearch.image` | `elasticsearch:6.5.4` | Elasticsearch image to use |
| `elasticsearch.replicas` | `2` | Elasticsearch nodes (must be >= 2) |
| `elasticsearch.memory` | `1g` | Memory allocated per ES node |
| `elasticsearch.storage.size` | `10Gi` | Size of ES Persistent Volume |
| `elasticsearch.storage.class` | `standard` | Storage Class of ES PV |

#### Without Ingress

```bash
helm install helm/chart/ --name=akeneo-demo --namespace=akeneo --set-string akeneo.version=3.2
```

Then run:

```bash
kubectl -n akeneo port-forward svc/akeneo-service 8080
```

Open http://localhost:8080 and login with `admin` / `admin`.

#### With an Ingress

```bash
helm install helm/chart/ --name=akeneo-demo --namespace=akeneo \
    --set akeneo.ingress.enabled=true --set akeneo.ingress.hostname=my.host.name
```

See `helm/chart/values.yaml` for default & available config values.

---

Once you're done giving Akeneo a try, you may delete the whole stack:

```bash
helm delete --purge akeneo-demo
```

### With `docker-compose`

> _Optional step: build the image running `make build` within this directory._

You may use the following `docker-compose.yml` sample:

```yaml
version: '3'
services:
  php:
    image: clickandmortar/akeneo:3.2-demo
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

- [ ] Use `ConfigMap`s for vhost, PHP config and `parameters.yml`
- [ ] Use environment variables for config within `parameters.yml`
- [ ] Add resources for workloads
- [ ] Store passwords in Secrets
- [ ] Setup Akeneo cron tasks as Kubernetes `CronJob`s
- [x] Automatically run DB installer (`pim:installer:db` command) on deployment: init Job created
- [x] Test scaling up Akeneo deployment: ✅ once DB is initialized
- [x] Run a separate Deployment for the queue consumer
- [x] Remove mandatory use Ingress Controller
- [x] Allow using a custom Akeneo image
