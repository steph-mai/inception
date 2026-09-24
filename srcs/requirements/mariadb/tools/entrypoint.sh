#!/bin/bash
set -e

if [ -f "/run/secrets/db_password" ]; then
    . /run/secrets/db_password
fi

if [ -f "/run/secrets/db_root_password" ]; then
    . /run/secrets/db_root_password
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql >/dev/null 2>&1
fi

mysqld --user=mysql --skip-networking &
pid=$!

for i in $(seq 1 30); do
    if mysqladmin ping --silent >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

for i in $(seq 1 30); do
    if mysqladmin ping --silent >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'\%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

if mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" ping --silent >/dev/null 2>&1; then
    mysql -uroot -p"${SQL_ROOT_PASSWORD}" < /tmp/init.sql
else
    mysql -uroot < /tmp/init.sql
fi

mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
wait $pid

exec mysqld --user=mysql
