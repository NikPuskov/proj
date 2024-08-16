#!/bin/bash

MYSQL='mysql -h127.0.0.1 -P3305'
SLAVE='mysql -h127.0.0.1 -P3308'
$MYSQL -e "CREATE USER repl@'%' IDENTIFIED WITH 'caching_sha2_password' BY 'superuser';";
$MYSQL -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%';";

$MYSQL -e "select user, host, plugin from mysql.user;";

rezult=$($MYSQL -N -e "SHOW MASTER STATUS;";)
read binlog position <<< $rezult
echo $binlog
echo $position

$SLAVE -e "CHANGE MASTER TO MASTER_HOST='172.17.0.1', MASTER_PORT=3305, MASTER_USER='repl', MASTER_PASSWORD='superuser', MASTER_LOG_FILE='$binlog', MASTER_LOG_POS=$position, GET_MASTER_PUBLIC_KEY = 1;";
$SLAVE -e 'start slave;';
