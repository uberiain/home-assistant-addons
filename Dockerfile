# 1. Use PHP 8.2 FPM (FastCGI Process Manager) for Nginx compatibility
FROM php:8.2-fpm-bookworm

# 2. Install Nginx, Supervisor, and ipmitool
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    nginx \
    supervisor \
    ipmitool \
    libzip-dev \
    && rm -rf /var/lib/apt/lists/*

# 3. Install PHP extensions needed for IPMI/Web
RUN docker-php-ext-install bcmath pcntl zip

# 4. Configure Nginx
COPY ./docker/nginx.conf /etc/nginx/sites-available/default

# 5. Configure Supervisor (to run both PHP & Nginx)
COPY ./docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 6. Set up your app
WORKDIR /var/www/html
COPY ./ipmi-server/rootfs/app /var/www/html

# 7. Expose Web Port
EXPOSE 80

# 8. Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
