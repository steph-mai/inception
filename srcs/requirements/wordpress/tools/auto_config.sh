#!/bin/bash
set -e

if [ -f "/run/secrets/credentials" ]; then
    . /run/secrets/credentials
fi

if [ -f "/run/secrets/db_password" ]; then
    . /run/secrets/db_password
fi

until (echo > /dev/tcp/mariadb/3306) >/dev/null 2>&1; do
    sleep 1
done

if [ ! -f /var/www/wordpress/wp-config.php ]; then

    wp config create \
        --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --path='/var/www/wordpress'

    wp core install \
        --allow-root \
        --url="$DOMAIN_NAME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path='/var/www/wordpress'

    wp user create \
        --allow-root \
        "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role=author \
        --path='/var/www/wordpress'

    chown -R www-data:www-data /var/www/wordpress
fi

exec /usr/sbin/php-fpm8.2 -F
