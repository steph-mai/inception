#!/bin/bash
set -e

echo "Starting MariaDB entrypoint..."

if [ -f "/run/secrets/db_password" ]; then
    . /run/secrets/db_password
fi

if [ -f "/run/secrets/db_root_password" ]; then
    . /run/secrets/db_root_password
fi

echo "Checking initialization flag..."
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "Initializing database..."
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
    echo "Database initialized"
else
    echo "Database already initialized"
fi

exec mysqld --user=mysql
