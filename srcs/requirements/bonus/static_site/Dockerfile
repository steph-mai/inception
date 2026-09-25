FROM debian:bookworm

RUN apt-get update -y && apt-get install -y python3

RUN mkdir -p /var/www/static
COPY conf/* /var/www/static/

WORKDIR /var/www/static

CMD ["python3", "-m", "http.server", "8080"]
