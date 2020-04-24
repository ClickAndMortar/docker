# Kubernetes deployer Docker

Docker image with necessary tools installed to deploy to Kubernetes using Helm:

* Helm
* Helm secrets plugin
* GnuPG
* kubectl

This Docker image can be useful in GitLab CI for instance to avoid rebuilding deploy image each time.

## Usage

```bash
docker pull clickandmortar/k8s-deployer
```

Available tags:

* `buster-helm3`: Debian Buster based with Helm 3
* `latest`: references `buster-helm3`
