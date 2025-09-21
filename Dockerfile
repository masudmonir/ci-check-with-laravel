# FROM php:8.3-cli
# FROM php:8.3-apache
# # Enable mod_rewrite
# RUN a2enmod rewrite

# # Install system dependencies
# RUN apt-get update && apt-get install -y \
#     git curl zip unzip libonig-dev libzip-dev libxml2-dev \
#     libpng-dev libjpeg-dev libfreetype6-dev \
#     libcurl4-openssl-dev pkg-config \
#     && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd opcache

# RUN pecl install xdebug \
#     && docker-php-ext-enable xdebug

# # Set working directory
# WORKDIR /var/www/html

# # Install Composer (first!)
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Copy composer files first (for caching)
# COPY composer.json composer.lock ./

# # Install PHP dependencies
# RUN composer install --prefer-dist --no-interaction --no-progress --no-scripts

# # Copy the rest of the app
# COPY . .

# # Set document root to public/
# ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# # Fix Apache config for public folder
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# # Set permissions
# # RUN chown -R www-data:www-data /var/www/html \
# #     && chmod -R 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
#     && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache




# # Use PHP 8.3 image with Apache
# FROM php:8.3-apache

# # Enable Apache mod_rewrite
# RUN a2enmod rewrite

# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     git curl zip unzip libonig-dev libzip-dev libxml2-dev \
#     libpng-dev libjpeg-dev libfreetype6-dev \
#     libcurl4-openssl-dev pkg-config \
#     && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd opcache

# # Enable curl & json extensions (if not default)
# RUN docker-php-ext-enable curl json



# # Set working directory
# WORKDIR /var/www/html

# # Copy app source code
# COPY . /

# # Install Composer
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# RUN composer install --prefer-dist --no-interaction --no-progress

# # Set permissions
# RUN chown -R www-data:www-data /var/www/html \
#     && chmod -R 755 /var/www/html

# # Enable Laravel .htaccess
# COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf



# Stage 1: Base
# FROM php:8.3-apache AS base
# RUN a2enmod rewrite \
#  && apt-get update && apt-get install -y \
#     git curl zip unzip libonig-dev libzip-dev libxml2-dev \
#     libpng-dev libjpeg-dev libfreetype6-dev \
#     libcurl4-openssl-dev pkg-config \
#  && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd opcache

# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# WORKDIR /var/www/html
# ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
# RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# # Stage 2: Dev
# FROM base AS dev
# RUN pecl install xdebug && docker-php-ext-enable xdebug
# COPY . .
# RUN composer install --prefer-dist --no-interaction --no-progress
# RUN chown -R www-data:www-data storage bootstrap/cache \
#  && chmod -R 775 storage bootstrap/cache

# # Stage 2: Dev
# FROM base AS test
# RUN pecl install xdebug && docker-php-ext-enable xdebug
# COPY . .
# RUN composer install --prefer-dist --no-interaction --no-progress
# RUN chown -R www-data:www-data storage bootstrap/cache \
#  && chmod -R 775 storage bootstrap/cache

# # Stage 3: Prod
# FROM base AS prod
# COPY . .
# # COPY .env.prod /var/www/html/.env
# RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress
# RUN php artisan config:cache && php artisan route:cache && php artisan view:cache
# RUN chown -R www-data:www-data storage bootstrap/cache \
#  && chmod -R 777 storage bootstrap/cache


# Stage 1: Base PHP + Apache
FROM php:8.3-apache AS base
RUN a2enmod rewrite \
 && apt-get update && apt-get install -y \
    git curl zip unzip libonig-dev libzip-dev libxml2-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libcurl4-openssl-dev pkg-config \
 && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# ----------------------------------------------------------
# Stage 2: Node for Vite build
FROM node:18 AS node_builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build   # 👉 generates public/build + manifest.json

# ----------------------------------------------------------
# Stage 3: Dev
FROM base AS dev
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY . .
RUN composer install --prefer-dist --no-interaction --no-progress
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# ----------------------------------------------------------
# Stage 4: Test (same as dev but separate target)
FROM base AS test
RUN pecl install xdebug && docker-php-ext-enable xdebug
COPY . .
RUN composer install --prefer-dist --no-interaction --no-progress
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# ----------------------------------------------------------
# Stage 5: Prod
FROM base AS prod
COPY . .

# Copy built Vite assets from node_builder
COPY --from=node_builder /app/public/build ./public/build

# If you want to inject a custom env at build time
# COPY .env.prod /var/www/html/.env

RUN composer install --no-dev --optimize-autoloader --no-interaction --no-progress
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 777 storage bootstrap/cache