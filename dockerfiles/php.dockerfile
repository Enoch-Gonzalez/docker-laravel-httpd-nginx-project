FROM php:8.0-fpm-alpine
 
WORKDIR /var/www/html
 
COPY src .

#COPY ../scripts/start.sh /usr/local/bin/start.sh

# Make the start.sh script executable
RUN chmod +x /usr/local/bin/start.sh
 
RUN docker-php-ext-install pdo pdo_mysql
 
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel 
 
# RUN chown -R laravel:laravel .

CMD ["php-fpm"]