FROM bryanlatten/docker-php:9
MAINTAINER Jim DeLois <delois@adobe.com>

ENV CONF_PHP_XDEBUG=$CONF_PHPMODS/xdebug.ini \
    CONF_PHP_BLACKFIRE=$CONF_PHPMODS/blackfire.ini

# Manual installation of Blackfire Probe
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && mkdir /usr/lib/blackfire \
    && curl -A "Docker" -o /usr/lib/blackfire/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /usr/lib/blackfire/blackfire-probe.tar.gz -C /usr/lib/blackfire \
    && ln -s /usr/lib/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so

# Layer customizations over existing structure
COPY ./container/root /

COPY ./ /app/
