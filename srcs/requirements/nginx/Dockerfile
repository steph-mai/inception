FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx vim curl openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=ARA/L=Lyon/O=42/OU=42/CN=stmaire.42.fr/UID=stmaire"

RUN mkdir -p /var/run/nginx /var/www/wordpress && \
    chmod 755 /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
