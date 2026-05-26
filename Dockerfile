# ================================
# STAGE 1 — INSTALL PHP DEPENDENCIES
# ================================
FROM composer:2 AS composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader\
    --no-scripts

# ================================
# STAGE 2 — APPLICATION IMAGE
# ================================
FROM php:8.3-fpm-alpine

# Install required system packages
RUN apk add --no-cache \
    bash \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    unzip \
    oniguruma-dev \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql \
    mbstring \
    zip \
    exif \
    pcntl \
    gd

# Set working directory
WORKDIR /var/www

# Copy application files
COPY . .

# Copy vendor from composer stage
COPY --from=composer /app/vendor ./vendor

# Set proper permissions
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# Expose php-fpm port
EXPOSE 9000

CMD ["php-fpm"]
