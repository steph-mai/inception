#!/bin/bash
set -e

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

if mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" ping --silent >/dev/null 2>&1; then
    ROOT_AUTH=(-uroot -p"${SQL_ROOT_PASSWORD}")
else
    ROOT_AUTH=(-uroot)
fi

mysql "${ROOT_AUTH[@]}" -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql "${ROOT_AUTH[@]}" -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql "${ROOT_AUTH[@]}" -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';"
mysql "${ROOT_AUTH[@]}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql "${ROOT_AUTH[@]}" -e "FLUSH PRIVILEGES;"

mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
wait $pid

exec mysqld --user=mysql
