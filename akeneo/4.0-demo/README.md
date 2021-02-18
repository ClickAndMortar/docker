# Akeneo 4.0 Demo

This repo provides the following:

* Fully-packaged Docker image for Akeneo 4.0 🐳
* Helm chart to deploy the demo on Kubernetes ☁

Those can be used to easily deploy a working demo of Akeneo 4.0 🚀.

## Usage

### With Kubernetes, using Helm

Available configuration values:

| Name | Default | Info |
|---|---|---|
| `akeneo.version` | `4.0` | Version to install / use |
| `akeneo.image` | `clickandmortar/akeneo:4.0-demo` | Custom Docker image to use (must listen for HTTP) |
| `akeneo.replicas` | `1` | Number of Akeneo instances |
| `akeneo.ingress.enabled` | `false` | Enable use of Ingress |
| `akeneo.ingress.hostname` | none | Hostname for Ingress |
| `akeneo.ingress.https` | `false` | Enable HTTPS for Ingress |
| `akeneo.ingress.certmanagerClusterIssuer` | none | Cert Manager Cluster Issuer name |
| `akeneo.port` | `80` | HTTP port the image is listening on |
| `mysql.external` | `false` | Use external MySQL |
| `mysql.image` | `mysql:8.0` | MySQL image to use |
| `mysql.user` | `akeneo` | MySQL username |
| `mysql.password` | `akeneo` | MySQL password |
| `mysql.host` | Auto-generated | MySQL host |
| `mysql.port` | `3306` | MySQL port |
| `mysql.storage.size` | `20Gi` | Size of MySQL Persistent Volume |
| `mysql.storage.class` | `standard` | Storage Class of MySQL PV |
| `elasticsearch.external` | `false` | Use external Elasticsearch |
| `elasticsearch.image` | `docker.elastic.co/elasticsearch/elasticsearch-oss:7.5.2` | Elasticsearch image to use |
| `elasticsearch.host` | Auto-generated | Elasticsearch host |
| `elasticsearch.port` | `9200` | Elasticsearch port |
| `elasticsearch.memory` | `512m` | Memory allocated to ES |
| `elasticsearch.storage.size` | `10Gi` | Size of ES Persistent Volume |
| `elasticsearch.storage.class` | `standard` | Storage Class of ES PV |
| `objectStorage.enabled` | `true` | Use external object storage (uses Minio) |
| `objectStorage.bucket` | `akeneo` | Name of bucket |
| `objectStorage.region` | `us-east-1` | AWS Region (when applicable) |
| `objectStorage.adapter` | `s3` | Object storage adapter (only S3 supported at the moment) |
| `objectStorage.minio.enabled` | `true` | Install Minio |
| `objectStorage.minio.port` | `9000` | Minio port |
| `objectStorage.minio.username` | See `values.yaml` | Username / access key |
| `objectStorage.minio.password` | See `values.yaml` | Password / access secret |
| `objectStorage.minio.storage.size` | `10Gi` | Minio persistent storage size |
| `objectStorage.minio.storage.class` | `standard` | Minio persistent storage class |

#### Without Ingress

```bash
helm install helm/chart/ --name=akeneo-demo --namespace=akeneo --set-string akeneo.version=4.0
```

Then run:

```bash
kubectl -n akeneo port-forward svc/akeneo-service 80:8080
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

## Coming enhancements

- [x] Add shared storage for jobs (Minio or `PersistentVolume` with `ReadWriteMany` support)
- [ ] Add resources for workloads
- [ ] Setup Akeneo cron tasks as Kubernetes `CronJob`s
- [ ] Add support for Redis for cache and/or sessions
- [x] Refactor Dockerfile
- [ ] Build base image suitable for custom Akeneo install
- [ ] Switch to Composer 2
- [ ] Make DB init and admin user create optional
- [x] Allow usage of external MySQL / Elasticsearch
- [ ] Add affinities support
- [ ] And taint/tolerations support
