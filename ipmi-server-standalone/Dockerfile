# 1. Pull the official composer binary from its own image
FROM composer:latest AS composer_stage

# 2. Start your main PHP image
FROM php:8.2-fpm-alpine

# 3. Install system dependencies
RUN apk add --no-cache \
    nginx \
    supervisor \
    ipmitool \
    bash \
    libzip-dev \
    # Required for composer to work on Alpine
    libintl \
    icu-dev \
    git \
    oniguruma-dev

# 4. Install PHP extensions
RUN docker-php-ext-install bcmath pcntl zip mbstring intl

# 5. Configure Nginx & Supervisor
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 6. Set up app
WORKDIR /var/www/html
COPY ../ipmi-server/rootfs/app /var/www/html

# 7. Copy Composer from the builder stage
COPY --from=composer_stage /usr/bin/composer /usr/bin/composer

# 8. Run Composer as the www-data user for better security
# We use 'php' directly because the official image provides the binary at /usr/local/bin/php
RUN php /usr/bin/composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction \
    --working-dir /var/www/html

# 9. Final Permissions Fix
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
