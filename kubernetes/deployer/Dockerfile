FROM debian:buster

MAINTAINER Click & Mortar <contact@clickandmortar.fr>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bash \
    git \
    openssl \
    curl \
    bc \
    gnupg \
    sudo \
    && rm -rf /var/lib/apt/lists/*

ENV HELM_VERSION="v3.1.2"

RUN curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash -s -- --version ${HELM_VERSION} \
    && mkdir -p ${HELM_HOME}/plugins \
    && helm plugin install https://github.com/futuresimple/helm-secrets \
    && curl -sSL https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

COPY gpg-wrapper.sh /usr/local/bin/gpg-wrapper
