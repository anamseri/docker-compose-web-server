FROM php:8.4-fpm-alpine

ARG PATH_VAR_WWW
ENV PATH_VAR_WWW=${PATH_VAR_WWW}
ARG HOST_UID=${HOST_UID}
ARG HOST_GID=${HOST_GID}

RUN apk add --no-cache \
    bash \
    git \
    unzip \
    curl \
    icu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    $PHPIZE_DEPS

RUN docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
 && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        zip \
        gd \
        intl \
        mbstring \
        xml \
        opcache

RUN apk del $PHPIZE_DEPS \
 && rm -rf /var/cache/apk/*

RUN set -eux; \
    if id www-data >/dev/null 2>&1; then \
        deluser www-data; \
    fi; \
    if getent group www-data >/dev/null 2>&1; then \
        delgroup www-data; \
    fi; \
    addgroup -g ${HOST_GID} www-data; \
    adduser -D -u ${HOST_UID} -G www-data www-data

RUN mkdir -p /var/www/${PATH_VAR_WWW} \
 && chown -R www-data:www-data /var/www/${PATH_VAR_WWW}

WORKDIR /var/www/${PATH_VAR_WWW}

COPY php.ini /usr/local/etc/php/conf.d/99-custom.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.enable_cli=0"; \
    echo "opcache.memory_consumption=256"; \
    echo "opcache.interned_strings_buffer=16"; \
    echo "opcache.max_accelerated_files=20000"; \
    echo "opcache.validate_timestamps=1"; \
    echo "opcache.revalidate_freq=2"; \
} > /usr/local/etc/php/conf.d/opcache.ini

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer

USER www-data

EXPOSE 9000

CMD ["php-fpm"]
