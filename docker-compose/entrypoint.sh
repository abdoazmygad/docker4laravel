#!/bin/bash
# entrypoint.sh

# Start the service
php artisan migrate
php artisan config:clear
php artisan cache:clear
php artisan config:cache

# Execute the CMD passed from Dockerfile or docker-compose.yml
exec "$@"