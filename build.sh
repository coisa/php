#!/usr/bin/env bash
set -x

build() {
  docker build --tag "coisa/php:${1}" --build-arg PHP_VERSION="${1}" --file Dockerfile .
}

push() {
  docker push "coisa/php:${1}"
}

run() {
  build "${1}" && push "${1}"
}

declare -a PHP_VERSIONS=("8" "8.1" "8.0" "7.4" "7.3" "7.2" "7.1" "7.0" "5.6" "5.3")
declare -a PHP_VARIATIONS=("cli" "apache" "fpm" "fpm-alpine" "alpine")

run "latest"

for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
  run ${PHP_VERSION}

  for PHP_VARIATION in "${PHP_VARIATIONS[@]}"; do
    run "${PHP_VERSION}-${PHP_VARIATION}"
  done
done
