#!/bin/sh

function get_php_extensions() {
    EXTENSIONS='
php5-apcu
php5-bcmath
php5-bz2
php5-calendar
php5-ctype
php5-curl
php5-dom
php5-exif
php5-gd
php5-gettext
php5-gmp
php5-imagick
php5-imap
php5-intl
php5-json
php5-ldap
php5-mcrypt
php5-mysqli
php5-mysql
php5-opcache
php5-openssl
php5-pcntl
php5-pdo
php5-pdo_mysql
php5-pdo_sqlite
php5-phar
php5-posix
php5-shmop
php5-sockets
php5-sqlite3
php5-xdebug
php5-xml
php5-xmlreader
php5-xsl
php5-zip
';
# php5-zlib is not installed, as it is only a virtual package.
# The extensions php5-redis and php5-iconv are not installed, as they are broken on alpine.
# Use symfony/polyfill-iconv respective predis/predis instead when necessary.

    echo "$EXTENSIONS";

    exit 0;
}

function get_php_extensions_default() {
    EXTENSIONS='
php5-ctype
php5-dom
php5-json
php5-mbstring
php5-openssl
php5-phar
php5-posix
php5-simplexml
php5-tokenizer
php5-xml
php5-xmlwriter
php5-zip
';

    echo "$EXTENSIONS";

    exit 0;
}
