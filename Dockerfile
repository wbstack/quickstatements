FROM composer:2.8 as composer

WORKDIR /installing
COPY ./ /installing
RUN composer install --no-dev --no-progress && rm -rf vendor/wbstack/magnustools


FROM php:8.1-apache

LABEL org.opencontainers.image.source="https://github.com/wbstack/quickstatements"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        libasprintf0v5=0.21-12 \
        jq=1.6-2.1 \
        libicu-dev=72.1-3 \
        icu-devtools=72.1-3 && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    pecl install redis-6.1.0 && \
    docker-php-ext-enable redis

ENV APACHE_DOCUMENT_ROOT /var/www/html/quickstatements/public_html
#TODO do 2 tuns in 1 layer..
RUN sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf && \
    sed -ri -e "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/php.ini /usr/local/etc/php/conf.d/php.ini

RUN install -d -owww-data /var/log/quickstatements

COPY --from=composer /installing /var/www/html/quickstatements
COPY --from=composer /installing/classes /var/www/html/magnustools/classes
COPY --from=composer /installing/public_html/php /var/www/html/magnustools/public_html/php

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
