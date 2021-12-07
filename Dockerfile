ARG PHP_VERSION="alpine"
FROM php:${PHP_VERSION}
COPY --from=composer /usr/bin/composer /usr/bin/composer
