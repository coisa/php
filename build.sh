#!/usr/bin/env bash

build() {
  IMAGE_NAME="coisa/php"
  IMAGE_TAG="${1}"

  BUILD_IMAGE="${IMAGE_NAME}:${IMAGE_TAG}"

  echo "Building ${BUILD_IMAGE}..."

  docker pull "php:${IMAGE_TAG}"
  docker build --tag ${BUILD_IMAGE} --build-arg PHP_VERSION="${IMAGE_TAG}" --file Dockerfile .
}

declare -a PHP_VERSIONS=("8" "8.1" "8.0" "7.4" "7.3" "7.2" "7.1" "7.0" "5.6" "5.3")
declare -a PHP_VARIATIONS=("cli" "apache" "fpm" "fpm-alpine" "alpine")

build "latest"

for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
  build ${PHP_VERSION}

  for PHP_VARIATION in "${PHP_VARIATIONS[@]}"; do
    build "${PHP_VERSION}-${PHP_VARIATION}"
  done
done

docker push --all-tags coisa/php