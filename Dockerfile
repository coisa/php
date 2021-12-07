ARG PHP_VERSION="alpine"
FROM php:${PHP_VERSION}

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp

RUN set -eux \
    ; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && \
    php composer-setup.php -- \
        --quiet \
        --install-dir=/usr/bin \
        --filename=composer \
    && \
    php -r "unlink('composer-setup.php');" \
    && \
    chmod +x /usr/bin/composer \
    && \
    apk add \
    --no-cache \
    --virtual .composer-rundeps \
        p7zip \
        git \
        make \
        openssh-client \
        unzip \
        zip \
        libzip-dev \
    || \
    ( \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            p7zip-full \
            git \
            make \
            openssh-client \
            unzip \
            zip \
            libzip-dev \
            libbz2-dev \
        ; \
    ) && \
    docker-php-ext-install \
        bz2 \
        zip \
    && \
    composer diagnose