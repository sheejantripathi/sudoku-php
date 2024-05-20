#!/bin/bash

# Check if the vendor directory exists and install Composer dependencies if not
if [ ! -f "vendor/autoload.php" ]; then
    composer install --no-progress --no-interaction
fi

# Check if the .env file exists and create it if not
if [ ! -f ".env" ]; then
    echo "Creating .env file"
    cp .env.example .env
fi


# Start PHP-FPM in the background
php-fpm -D

# Start Nginx in the foreground
nginx -g "daemon off;"
