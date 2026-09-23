FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget php8.2 php-fpm php-mysql mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://fr.wordpress.org/wordpress-6.4-fr_FR.tar.gz -P /var/www && \
    tar -xzf /var/www/wordpress-6.4-fr_FR.tar.gz -C /var/www/ && \
    rm /var/www/wordpress-6.4-fr_FR.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN mkdir -p /run/php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

ENTRYPOINT ["auto_config.sh"]
