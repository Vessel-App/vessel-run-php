#!/usr/bin/env bash

set -eux

docker build --build-arg "PHP_VERSION=8.1" -t vesselapp/php:8.1 .
docker push vesselapp/php:8.1

docker build --build-arg "PHP_VERSION=8.0" -t vesselapp/php:8.0 .
docker push vesselapp/php:8.0

docker build --build-arg "PHP_VERSION=7.4" -t vesselapp/php:7.4 .
docker push vesselapp/php:7.4