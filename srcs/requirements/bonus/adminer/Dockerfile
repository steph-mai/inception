FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y php8.2-fpm php8.2-mysql wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer /run/php

RUN wget -O /var/www/adminer/adminer.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

CMD ["/usr/sbin/php-fpm8.2", "-F"]
