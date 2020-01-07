ARG REGISTRY_PATH=gmitirol
FROM $REGISTRY_PATH/alpine38:1.2.10
LABEL maintainer="gmi-edv@i-med.ac.at"

ARG ALPINE_MIRROR_BASE="http://dl-cdn.alpinelinux.org"

ADD scripts/ /usr/local/bin/
ADD tools/ /usr/local/bin/

# install PHP5 + extensions, disable non-default extensions
# Alpine 3.5 repositories are added for PHP extensions (imagick, xdebug) plus their deps
RUN set -xe && \
  echo "${ALPINE_MIRROR_BASE}/alpine/v3.5/main" >> /etc/apk/repositories && \
  echo "${ALPINE_MIRROR_BASE}/alpine/v3.5/community" >> /etc/apk/repositories && \
  sh /usr/local/bin/install-php.sh && \
  rm /usr/local/bin/install-php.sh && \
  sh /usr/local/bin/php-ext.sh disable-non-default && \
  sh /usr/local/bin/php-ext.sh show && \
  sh /usr/local/bin/install-nginx.sh && \
  rm /usr/local/bin/install-nginx.sh && \
  echo 'TLS_CACERT /etc/ssl/certs/ca-certificates.crt' >> /etc/openldap/ldap.conf

RUN set -xe && \
  /bin/sed -i \
    -e 's#^expose_php =.*#expose_php = Off#' \
    -e "s#^date\.timezone =.*#date.timezone = $(cat /etc/TZ)#" \
    /etc/php5/php.ini

# install composer and tools
RUN set -xe && \
  sh /usr/local/bin/install-composer.sh && \
  rm /usr/local/bin/install-composer.sh && \
  mv /usr/local/bin/sami3.phar /usr/local/bin/sami && \
  mv /usr/local/bin/phpcs3.phar /usr/local/bin/phpcs

# create locked project user with user ID 1000
RUN set -xe && \
  adduser -u 1000 -D project;

# add build info
ADD PHP_BUILD /

# optionally store github token in image
ARG GITHUB_TOKEN
RUN if [ -n "$GITHUB_TOKEN" ] ; then \
      sh /usr/local/bin/setup-github-token.sh $GITHUB_TOKEN ; \
    fi
