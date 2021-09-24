FROM composer@sha256:d374b2e1f715621e9d9929575d6b35b11cf4a6dc237d4a08f2e6d1611f534675 as composer
# composer is pinned at a PHP 7 version

WORKDIR /installing
COPY ./ /installing
RUN composer install --no-dev --no-progress && rm -rf vendor/wbstack/magnustools


FROM php:8.0.11-apache

LABEL org.opencontainers.image.source="https://github.com/wbstack/quickstatements"

# For session storage
RUN pecl install redis-4.0.1 && docker-php-ext-enable redis

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