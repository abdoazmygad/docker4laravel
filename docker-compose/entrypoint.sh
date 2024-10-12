#!/bin/sh

php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache
php artisan migrate
# Fix files ownership.
# chown -R www-data .
# chown -R www-data /app/storage
# chown -R www-data /app/storage/logs
# chown -R www-data /app/storage/framework
# chown -R www-data /app/storage/framework/sessions
# chown -R www-data /app/bootstrap
# chown -R www-data /app/bootstrap/cache

# # Set correct permission.
# chmod -R 775 /app/storage
# chmod -R 775 /app/storage/logs
# chmod -R 775 /app/storage/framework
# chmod -R 775 /app/storage/framework/sessions
# chmod -R 775 /app/bootstrap
# chmod -R 775 /app/bootstrap/cache
