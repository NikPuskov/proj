#!/bin/bash

docker build -t nginx1 ./Nginx
echo "\033[32m Создание Docker-образа Nginx выполнено успешно"
tput sgr0
docker run -d --name nginx --network=host -p 80:80 -v /var/log/nginx:/var/log/nginx nginx1
echo "\033[32m Docker-контейнер Nginx запущен успешно"
tput sgr0
docker build -t httpd1 ./Httpd
echo "\033[32m Создание Docker-образа Httpd выполнено успешно"
tput sgr0
docker run -d --name httpd -p 8080:8080 -p 8081:8081 -p 8082:8082 httpd1
echo "\033[32m Docker-контейнер Httpd запущен успешно"
tput sgr0
cp /root/proj/.my.cnf /root/.my.cnf
echo "\033[32m Копирование конфига для MySQL успешно завершено"
tput sgr0
docker build -t slave ./MySQL
echo "\033[32m Создание Docker-образа MySQL-Slave успешно завершено"
tput sgr0
docker run --name mysql-slave -p 3308:3306 -e MYSQL_ROOT_PASSWORD=superuser -d slave
echo "\033[32m Docker-контейнер MySQL-Slave запущен успешно"
tput sgr0
docker run --name mysql-master -p 3305:3306 -e MYSQL_ROOT_PASSWORD=superuser -d mysql:8.0
echo "\033[32m Docker-контейнер MySQL-Master запущен успешно"
tput sgr0
sh /root/proj/MySQL/repl.sh
echo "\033[32m Скрипт репликации выполнен успешно"
tput sgr0
sh /root/proj/MySQL/backup.sh
echo "\033[32m Скрипт бэкапа БД с MySQL-Slave выполнен успешно"
tput sgr0
docker build -t prometheus ./Prometheus
echo "\033[32m Создание Docker-образа Prometheus успешно завершено"
tput sgr0
docker run -d --name prometheus -p 9090:9090 prometheus
echo "\033[32m Docker-контейнер Prometheus запущен успешно"
tput sgr0
docker run -d --name node_exporter -p 9100:9100 prom/node-exporter
echo "\033[32m Docker-контейнер Node_exporter запущен успешно"
tput sgr0
docker run -d --name grafana -p 3000:3000 grafana/grafana
echo "\033[32m Docker-контейнер Grafana запущен успешно"
tput sgr0
