FROM php:7.4-fpm-alpine

COPY ./php.ini /usr/local/etc/php/
COPY ./99-xdebug.ini /usr/local/etc/php/conf.d/
COPY ./symfony.pool.conf /etc/php-fpm.d/

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# RUN docker-php-ext-install pdo_mysql intl opcache

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions intl apcu opcache memcached igbinary pdo_mysql mysqli gearman mcrypt && \
    install-php-extensions mongodb  && \
    install-php-extensions xdebug
    # install-php-extensions xhprof

WORKDIR /var/www/symfony

EXPOSE 9000

CMD ["php-fpm", "-F", "-O", "--fpm-config=/etc/php-fpm.d/symfony.pool.conf"]
