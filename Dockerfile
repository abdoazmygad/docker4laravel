# Use PHP with Apache as the base image
FROM php:8.2-apache AS web

# Install Additional System Dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite for URL rewriting
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql zip

# Configure Apache DocumentRoot to point to Laravel's public directory
# and update Apache configuration files
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copy the application code
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN echo 'chown -R www-data:www-data /var/www/ \
            && cp .env.example .env'
# Install project dependencies
RUN composer install

# Set permissions
RUN mkdir -p ./storage/framework/{cache,testing,sessions,views,bootstrap/cache} && \
    chown -R www-data:www-data ./storage
# Adjust user permission & group
RUN usermod --uid 1000 www-data && \
    groupmod --gid 1000 www-data 


RUN echo 'chown -R www-data:www-data /var/www/ \
            && composer dump-autoload \
            && cp .env.example .env \
            && php artisan key:generate \       
            && php artisan config:cache \
            && php artisan migrate \
            && apachectl -D FOREGROUND' >> /root/container_init.sh && \
                chmod 755 /root/container_init.sh


# COPY ./docker-compose/wait-for-it.sh /usr/local/bin/wait-for-it.sh
# RUN chmod +x /usr/local/bin/wait-for-it.sh

# CMD ["/usr/local/bin/wait-for-it.sh", "mysql:3306", "--", "php", "artisan", "migrate"]

# Wait for MySQL to be ready before running migrations

# Add execution permission for the entrypoint file
# COPY docker-compose/entrypoint.sh /docker-compose/entrypoint.sh
# RUN chmod +x /docker-compose/entrypoint.sh

# Healthcheck (optional, depending on your application needs)
# HEALTHCHECK CMD curl --fail http://localhost:8000/ || exit 1

# Run the entrypoint file
# ENTRYPOINT ["/docker-compose/entrypoint.sh"]
