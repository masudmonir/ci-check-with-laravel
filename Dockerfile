FROM php:8.3-cli

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libonig-dev libzip-dev libxml2-dev \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libcurl4-openssl-dev pkg-config \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd opcache

# Set working directory
WORKDIR /var/www/html

# Copy app source code
COPY . /

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html



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