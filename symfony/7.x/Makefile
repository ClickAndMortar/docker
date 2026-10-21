# Les quatre étiquettes encore tirées par nos applis. --pull est indispensable : sans lui, buildx
# réutilise l'image php en cache et l'étiquette republiée garde l'ancien PHP.
#
# L'étiquette bullseye n'est plus construite : l'image officielle php:8.4-apache-bullseye est
# figée en 8.4.11 depuis le 05/08/2025 (Debian 11 abandonnée par docker-library), elle ne recevra
# plus aucun correctif. Les applis qui la tiraient passent en bookworm.
REPO     ?= clickandmortar/symfony
PLATFORM ?= linux/amd64
BUILD     = docker buildx build --pull --platform $(PLATFORM)

all: build

build: apache-php8.4 apache-php8.3 fpm-php8.4

apache-php8.4:
	$(BUILD) -f Dockerfile.apache --build-arg PHP_VERSION=8.4 -t $(REPO):7.x-apache-php8.4-bookworm $(PUSH) .

apache-php8.3:
	$(BUILD) -f Dockerfile.apache --build-arg PHP_VERSION=8.3 -t $(REPO):7.x-apache-php8.3-bookworm $(PUSH) .

fpm-php8.4:
	$(BUILD) -f Dockerfile.fpm --build-arg PHP_VERSION=8.4 -t $(REPO):7.x-fpm-php8.4-bookworm $(PUSH) .

# Construit et publie d'un coup : make push
push:
	$(MAKE) build PUSH=--push

# Version de PHP réellement embarquée par chaque étiquette publiée
versions:
	@for t in 7.x-apache-php8.4-bookworm 7.x-apache-php8.3-bookworm 7.x-fpm-php8.4-bookworm; do \
		docker pull -q --platform $(PLATFORM) $(REPO):$$t >/dev/null; \
		printf '%s\t' $$t; docker run --rm --platform $(PLATFORM) --entrypoint php $(REPO):$$t -r 'echo PHP_VERSION, PHP_EOL;'; \
	done

.PHONY: all build push versions apache-php8.4 apache-php8.3 fpm-php8.4
