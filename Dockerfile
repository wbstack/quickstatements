FROM node:12 as npm

WORKDIR /installing
COPY ./ /installing
RUN npm ci --only=production

FROM composer@sha256:d374b2e1f715621e9d9929575d6b35b11cf4a6dc237d4a08f2e6d1611f534675 as composer
# composer is pinned at a PHP 7 version

WORKDIR /installing
COPY ./ /installing

## 1. composer install
## 2. move magnus tools resources to a temp fold to select from (some are selected at the very end)
## 3. finally remove magnustools because it contains so much stuff
RUN composer install --no-dev --no-progress \
    && mv vendor/wbstack/magnustools /installing/magnustools \
    && rm -rf vendor/wbstack/magnustools

FROM php:7.2-apache

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

## TODO make some kind of sane magnus tools js lib to be included in the bundle
COPY --from=composer /installing/magnustools/public_html/resources /var/www/html/quickstatements/public_html/magnustools/resources
COPY --from=npm /installing/node_modules /var/www/html/quickstatements/public_html/resources

ENTRYPOINT ["/bin/bash"]
CMD ["/entrypoint.sh"]