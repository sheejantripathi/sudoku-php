FROM php:8.3.7-fpm as php

ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 
ENV PHP_OPCACHE_REVALIDATE_FREQ=1

RUN usermod -u 1000 www-data

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y unzip libpq-dev libcurl4-gnutls-dev nginx libonig-dev && \
    docker-php-ext-install pdo pdo_mysql bcmath curl opcache

WORKDIR /var/www

COPY --chown=www-data . .

COPY ./docker/php/php.ini /usr/local/etc/php/php.ini
COPY ./docker/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

# Ensure storage and bootstrap directories are writable
RUN chmod -R 755 /var/www/storage
RUN chmod -R 755 /var/www/bootstrap

ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["php-fpm"]
