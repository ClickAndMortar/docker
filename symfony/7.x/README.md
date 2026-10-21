# Symfony 7.x

Image de base des applis Symfony de Click & Mortar (Pimelo, PurpleScan, PerfHawk, Quorvana,
Quizendo, Texart, Uptimately, ion, vizually-app, website-2024).

| Étiquette | Base officielle |
|---|---|
| `clickandmortar/symfony:7.x-apache-php8.4-bookworm` | `php:8.4-apache-bookworm` |
| `clickandmortar/symfony:7.x-apache-php8.3-bookworm` | `php:8.3-apache-bookworm` |
| `clickandmortar/symfony:7.x-fpm-php8.4-bookworm` | `php:8.4-fpm-bookworm` |

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

Apache écoute sur 8080, l'appli vit dans `/app`, le processus tourne sous l'utilisateur `docker`.
