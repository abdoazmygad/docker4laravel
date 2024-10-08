#!/bin/bash

if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-ansi --no-dev --no-interaction --no-plugins --no-progress --no-scripts --optimize-autoloader
fi

if [ ! -f ".env" ]; then
    echo "Creating env file for env variables."
    cp .env.example .env
else
    echo "env file exists."
fi

# php artisan migrate
php artisan clear
php artisan optimize:clear
php artisan migrate
