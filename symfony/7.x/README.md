# Symfony 7.x

Image de base des applis Symfony de Click & Mortar (Pimelo, PurpleScan, PerfHawk, Quorvana,
Quizendo, Texart, Uptimately, ion, vizually-app, website-2024).

| Étiquette | Base officielle |
|---|---|
| `clickandmortar/symfony:7.x-apache-php8.4-bookworm` et `…php8.4.27-bookworm` | `php:8.4.27-apache-bookworm` |
| `clickandmortar/symfony:7.x-apache-php8.3-bookworm` et `…php8.3.36-bookworm` | `php:8.3.36-apache-bookworm` |
| `clickandmortar/symfony:7.x-fpm-php8.4-bookworm` et `…php8.4.27-bookworm` | `php:8.4.27-fpm-bookworm` |

`7.x-apache-php8.4-bullseye` n'est plus construite : sa base officielle est figée en PHP 8.4.11
depuis août 2025.

## Mettre à jour PHP

Après chaque version de sécurité de PHP, une fois l'image officielle reconstruite par
docker-library (quelques heures après l'annonce) :

```bash
make push      # reconstruit avec --pull et publie
make versions  # vérifie la version de PHP réellement publiée
```

Puis reconstruire chaque appli (sa CI tire l'image de base à chaque build sur `main`).

## Apache

Apache vient des paquets Debian de l'image officielle, qui ne suit bookworm-security qu'à sa
propre reconstruction. `Dockerfile.apache` le met donc à jour au build, et échoue si
`apache2-bin` reste sous `APACHE_MIN_VERSION` (2.4.71 depuis la CVE-2026-119618, RCE dans
mod_http2, novembre 2026). Au prochain correctif d'Apache : monter ce plancher, puis `make push`.

mod_http2 n'est pas activé par défaut (comme dans l'image officielle) ; `a2enmod http2` dans
l'image dérivée pour servir du HTTP/2.

Apache écoute sur 8080, l'appli vit dans `/app`, le processus tourne sous l'utilisateur `docker`.
