#! /bin/bash

MYSQL='mysql -uroot -psuperuser -h127.0.0.1 -P3308 --skip-column-names';

$MYSQL -e "STOP SLAVE;";

for s in `$MYSQL -e "SHOW DATABASES LIKE '%\_db'"`;
    do
        mkdir $s;
        for t in `$MYSQL -e "SHOW TABLES FROM $s"`;
                do
                        /usr/bin/mysqldump -uroot -psuperuser -h127.0.0.1 -P3308 --add-drop-table --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --events --routines --triggers $s $t | gzip -1 > $s/$t.gz;
                done
    done
$MYSQL -e "START SLAVE;";

