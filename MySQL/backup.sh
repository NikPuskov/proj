#! /bin/bash

MYSQL='mysql -h127.0.0.1 -P3308 --skip-column-names';

$MYSQL -e "STOP SLAVE;";

for s in `$MYSQL -e "SHOW DATABASES"`;
    do
        mkdir $s;
        for t in `$MYSQL -e "SHOW TABLES FROM $s"`;
                do
                      /usr/bin/mysqldump -h127.0.0.1 -P3308 --all-databases --source-data=2 --events --routines $s $t | gzip -1 > $s/$t.gz;
                done
    done
$MYSQL -e "START SLAVE;";
