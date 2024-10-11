# Use a specific version for better predictability
FROM php:8.3-fpm AS php

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libpq-dev \
    libcurl4-gnutls-dev \
    nginx \
    libonig-dev && \
    docker-php-ext-install mysqli pdo pdo_mysql bcmath curl opcache mbstring && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy composer executable
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# Copy configuration files
COPY ./docker-compose/php/local.ini /usr/local/etc/php/php.ini
COPY ./docker-compose/mysql /usr/local/etc/mysql/
COPY ./docker-compose/nginx/nginx.conf /etc/nginx/nginx.conf



# Set working directory to /app
WORKDIR /app

# Copy files from current folder to container
COPY --chown=www-data:www-data . .

# Create Laravel caching folders
RUN mkdir -p ./storage/framework/{cache,testing,sessions,views,bootstrap/cache} && \
    chown -R www-data:www-data ./storage

# Adjust user permission & group
RUN usermod --uid 1000 www-data && \
    groupmod --gid 1000 www-data

# Add execution permission for the entrypoint file
COPY docker-compose/entrypoint.sh /docker-compose/entrypoint.sh
RUN chmod +x /docker-compose/entrypoint.sh

# Healthcheck (optional, depending on your application needs)
HEALTHCHECK CMD curl --fail http://localhost:9000/ || exit 1

# Run the entrypoint file
ENTRYPOINT ["/docker-compose/entrypoint.sh"]
