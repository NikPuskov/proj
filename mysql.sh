bash /root/proj/MySQL/repl.sh
echo "\033[32m Скрипт репликации MySQL выполнен успешно"
tput sgr0
bash /root/proj/MySQL/backup.sh
echo "\033[32m Скрипт бэкапа БД с MySQL-Slave выполнен успешно"
