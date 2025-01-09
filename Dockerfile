FROM composer@sha256:4eb4765a70e95eb90badb8d04840068dcdfc72f92bff2db7c2a7b7cc41e7c10b as composer
# composer is pinned at a PHP 7 version

WORKDIR /installing
COPY ./ /installing
RUN composer install --no-dev --no-progress && rm -rf vendor/wbstack/magnustools


FROM php:7.2-apache

LABEL org.opencontainers.image.source="https://github.com/wbstack/quickstatements"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends gettext-base=0.19.8.1-9 jq=1.5+dfsg-2+b1 libicu-dev=63.1-6+deb10u3 && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    pecl install redis-4.0.1 && \
    docker-php-ext-enable redis

ENV APACHE_DOCUMENT_ROOT /var/www/html/quickstatements/public_html
#TODO do 2 tuns in 1 layer..
RUN sed -ri -e "s!/var/www/html!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/*.conf
RUN sed -ri -e "s!/var/www/!${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/php.ini /usr/local/etc/php/conf.d/php.ini

RUN install -d -owww-data /var/log/quickstatements

COPY --from=composer /installing /var/www/html/quickstatements
COPY --from=composer /installing/classes /var/www/html/magnustools/classes
COPY --from=composer /installing/public_html/php /var/www/html/magnustools/public_html/php

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]
