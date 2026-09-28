FROM debian:bookworm

RUN apt-get update && apt-get install -y wget

RUN wget https://github.com/filebrowser/filebrowser/releases/download/v2.28.0/linux-amd64-filebrowser.tar.gz
RUN tar -xvf linux-amd64-filebrowser.tar.gz
RUN mv filebrowser /usr/local/bin/

EXPOSE 5000

CMD ["filebrowser", "-r", "/var/www/wordpress", "-p", "5000", "-a", "0.0.0.0", "-b", "/files"]
