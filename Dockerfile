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

# Install the default object cache
RUN pecl channel-update pecl.php.net
RUN pecl install apcu
RUN docker-php-ext-enable apcu

#
# Tini
#
# See https://github.com/krallin/tini for the further details
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Remove packages which is not needed anymore (build dependencies of PHP extensions)
ONBUILD RUN apt-get autoremove -y --purge \
              build-essential \
              libicu-dev
