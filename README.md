# PHP Development Environment

This extends the `vesselapp/base:latest` Docker image and adds in PHP-related development packages.

This image is available at [hub.docker.com/vesselapp/php](https://hub.docker.com/vesselapp/php)

Tags available: PHP8+

* `vesselapp/php:8.0`
* `vesselapp/php:8.1`

## Building this Image

The following commands will build container images from this repository:

```bash
docker build --build-arg "PHP_VERSION=8.1" -t vesselapp/php:8.1 .

docker build --build-arg "PHP_VERSION=8.0" -t vesselapp/php:8.0 .
```
