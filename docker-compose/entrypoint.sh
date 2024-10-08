#!/bin/bash
if [ ! -f ".env" ]; then
    echo "Creating env file for env variables."
    cp .env.example .env
else
    echo "env file exists."
fi


if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-interaction 
fi

# php artisan test
php artisan config:cache
php artisan migrate
php artisan optimize:clear

# Fix files ownership.
chown -R www-data .
chown -R www-data /app/storage
chown -R www-data /app/storage/logs
chown -R www-data /app/storage/framework
chown -R www-data /app/storage/framework/sessions
chown -R www-data /app/bootstrap
chown -R www-data /app/bootstrap/cache

# Set correct permission.
chmod -R 775 /app/storage
chmod -R 775 /app/storage/logs
chmod -R 775 /app/storage/framework
chmod -R 775 /app/storage/framework/sessions
chmod -R 775 /app/bootstrap
chmod -R 775 /app/bootstrap/cache

php-fpm -D
nginx -g "daemon off;"

