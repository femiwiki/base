FROM php:7.2-fpm

# Install dependencies and utilities
RUN apt-get update && apt-get install -y \
      # Build dependencies
      build-essential \
      libicu-dev \
      # Runtime depenencies
      imagemagick \
      librsvg2-bin \
      # Required for SyntaxHighlighting
      python3 \
      # CLI utilities
      cron \
      sudo

# Install the PHP extensions we need
RUN docker-php-ext-install -j8 mysqli opcache intl

# Install the default object cache.
RUN pecl channel-update pecl.php.net
RUN pecl install apcu
RUN docker-php-ext-enable apcu
