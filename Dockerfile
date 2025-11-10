FROM php:8.2-apache-bookworm

# Omeka-S web publishing platform for digital heritage collections (https://omeka.org/s/)
# Previous maintainers: Oldrich Vykydal (o1da) - Klokan Technologies GmbH  / Eric Dodemont <eric.dodemont@skynet.be>
# MAINTAINER Giorgio Comai <g@giorgiocomai.eu>

RUN a2enmod rewrite

# Set default environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    APPLICATION_ENV=production

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Redirect Apache logs to stdout/stderr
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

# Install system dependencies required by PHP extensions and Omeka-S
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
        # Utils needed later
        unzip \
        wget \
        jq \
        ghostscript \
        poppler-utils \
        netcat-openbsd \
        # PHP Extension Runtime/Build-time Libs (-dev packages needed for compilation)
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        # libjpeg-dev # Likely redundant with libjpeg62-turbo-dev
        libpng-dev \
        zlib1g-dev \
        libicu-dev \
        libsodium-dev \
        # For Imagick extension
        imagemagick \
        libmagickwand-dev \
        zip \
        unzip \
        # for (IIIF) image processing
        libvips-tools \
    # Cleanup apt cache
    && apt-get clean

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install PHP extension installer tool
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install PHP extensions using the tool
# It will handle installing/removing temporary build dependencies (like build-essential)
RUN install-php-extensions \
    gd \
    iconv \
    pdo \
    pdo_mysql \
    mysqli \
    imagick \
    intl \
    xsl

# Add the Omeka-S PHP code
# Latest Omeka version, check: https://omeka.org/s/download/
RUN wget --no-verbose "https://github.com/omeka/omeka-s/releases/download/v4.1.1/omeka-s-4.1.1.zip" -O /var/www/latest_omeka_s.zip
RUN unzip -q /var/www/latest_omeka_s.zip -d /var/www/ \
&&  rm /var/www/latest_omeka_s.zip \
&&  rm -rf /var/www/html/ \
&&  mv /var/www/omeka-s/ /var/www/html/

COPY ./imagemagick-policy.xml /etc/ImageMagick-6/policy.xml

RUN chown -R www-data:www-data /var/www/html/ && chmod 600 /var/www/html/.htaccess

VOLUME /var/www/html/volume/

# Overwrite the original Docker PHP entrypoint
COPY docker-php-entrypoint /usr/local/bin/

# Copy the automatic installation script
COPY install_cli.php /var/www/html/

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
