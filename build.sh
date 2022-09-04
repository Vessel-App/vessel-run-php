#!/usr/bin/env bash

set -eux

docker build --build-arg "PHP_VERSION=8.1" -t vesselapp/php:8.1 .
docker push vesselapp/php:8.1

docker build --build-arg "PHP_VERSION=8.0" -t vesselapp/php:8.0 .
docker push vesselapp/php:8.0
