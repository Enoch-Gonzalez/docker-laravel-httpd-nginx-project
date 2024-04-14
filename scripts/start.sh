#!/bin/bash

# Run database migrations
php artisan migrate --force

# Run database seeders
php artisan db:seed --class=UserSeeder



