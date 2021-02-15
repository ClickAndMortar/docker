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
| `akeneo.image` | none | Custom Docker image to use (must listen for HTTP) |
| `akeneo.replicas` | `1` | Number of Akeneo instances |
| `akeneo.ingress.enabled` | `false` | Enable use of Ingress |
| `akeneo.ingress.hostname` | none | Hostname for Ingress |
| `akeneo.ingress.https` | `false` | Enable HTTPS for Ingress |
| `akeneo.ingress.certmanagerClusterIssuer` | none | Cert Manager Cluster Issuer name |
| `akeneo.port` | `80` | HTTP port the image is listening on |
| `mysql.image` | `mysql:8.0` | MySQL image to use |
| `mysql.storage.size` | `20Gi` | Size of MySQL Persistent Volume |
| `mysql.storage.class` | `standard` | Storage Class of MySQL PV |
| `elasticsearch.image` | `docker.elastic.co/elasticsearch/elasticsearch-oss:7.5.2` | Elasticsearch image to use |
| `elasticsearch.memory` | `512m` | Memory allocated to ES |
| `elasticsearch.storage.size` | `10Gi` | Size of ES Persistent Volume |
| `elasticsearch.storage.class` | `standard` | Storage Class of ES PV |

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
