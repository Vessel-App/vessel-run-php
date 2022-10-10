# syntax = docker/dockerfile:1.4

FROM vesselapp/base:latest

ARG PHP_VERSION=8.1
ARG NODE_MAJOR_VERSION=14

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

# Install and configure Nginx, PHP, Composer, NodeJS
RUN echo "Set disable_coredump false" >> /etc/sudo.conf \
    && mkdir -p /var/lib/dpkg \
    && touch /var/lib/dpkg/status \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y nginx \
       php${PHP_VERSION}-fpm php${PHP_VERSION}-cli \
       php${PHP_VERSION}-pgsql php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-gd \
       php${PHP_VERSION}-curl php${PHP_VERSION}-memcached \
       php${PHP_VERSION}-imap php${PHP_VERSION}-mysql php${PHP_VERSION}-mbstring \
       php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-bcmath php${PHP_VERSION}-soap \
       php${PHP_VERSION}-intl php${PHP_VERSION}-readline php${PHP_VERSION}-xdebug \
       php${PHP_VERSION}-msgpack php${PHP_VERSION}-igbinary  php${PHP_VERSION}-imagick \
       php${PHP_VERSION}-ldap php${PHP_VERSION}-gmp php${PHP_VERSION}-redis php${PHP_VERSION}-pcov \
    && php -r "readfile('http://getcomposer.org/installer');" | php${PHP_VERSION} -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir /run/php \
    && phpdismod -v ALL -s cli xdebug pcov \
    && sed -i 's/^user =.*$/user = vessel/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && sed -i 's/^group =.*$/group = vessel/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && sed -i 's/^listen.owner =.*$/listen.owner = vessel/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && sed -i 's/^listen.group =.*$/listen.group = vessel/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && sed -i 's/^;clear_env =.*$/clear_env = no/g' /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf \
    && sed -i 's/^display_errors = .*/display_errors = On/g' /etc/php/${PHP_VERSION}/fpm/php.ini \
    && sed -i 's/^display_errors = .*/display_errors = On/g' /etc/php/${PHP_VERSION}/cli/php.ini \
    \
    && sed -i 's/^user.*$/user vessel;/g' /etc/nginx/nginx.conf \
    \
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR_VERSION}.x | bash - \
    && apt-get install -y nodejs

COPY docker/nginx.conf /etc/nginx/sites-available/default
COPY docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN sed -i "s/8.1/${PHP_VERSION}/g" /etc/nginx/sites-available/default \
    && sed -i "s/8.1/${PHP_VERSION}/g" /etc/supervisor/conf.d/supervisor.conf \
    && apt-get clean autoclean \
	&& apt-get autoremove --yes
