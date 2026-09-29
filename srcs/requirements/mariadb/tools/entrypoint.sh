#!/bin/bash
set -e

if [ -f "/run/secrets/db_password" ]; then
    . /run/secrets/db_password
fi

if [ -f "/run/secrets/db_root_password" ]; then
    . /run/secrets/db_root_password
fi

if [ ! -f "/var/lib/mysql/.initialized" ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/dev/null 2>&1

    mysqld --user=mysql --skip-networking &
    pid=$!

    for i in $(seq 1 30); do
        mysqladmin ping --silent && break
        sleep 1
    done

    cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${SQL_USER}'@'wordpress' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'wordpress';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mysql -uroot < /tmp/init.sql
    mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
    wait $pid
    touch /var/lib/mysql/.initialized
fi

exec mysqld --user=mysql
