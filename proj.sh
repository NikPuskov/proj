#!/bin/bash

echo "\033[31m Аварийное восстановление микросервисной архитектуры"
tput sgr0
sleep 3
echo "\033[36m Web-сервер с балансировкой нагрузки"
tput sgr0
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
sleep 3
echo "\033[36m MySQL сервер с репликацией"
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
sleep 3
echo "\033[36m Мониторинг"
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
sleep 3
echo "\033[36m ELK-стек"
tput sgr0
docker build -t elastic1 ./Elastic
echo "\033[32m Создание Docker-образа Elasticsearch успешно завершено"
tput sgr0
docker run -d --name elastic --network=host -p 9200:9200 -p 9300:9300 elastic1
echo "\033[32m Docker-контейнер Elasticsearch запущен успешно"
tput sgr0
docker build -t kibana1 ./Kibana
echo "\033[32m Создание Docker-образа Kibana успешно завершено"
tput sgr0
docker run -d --name kibana --network=host -p 5601:5601 kibana1
echo "\033[32m Docker-контейнер Kibana запущен успешно"
tput sgr0
docker build -t logstash1 ./Logstash
echo "\033[32m Создание Docker-образа Logstash успешно завершено"
tput sgr0
docker run -d --name logstash --network=host -p 5400:5400 logstash1
echo "\033[32m Docker-контейнер Logstash запущен успешно"
tput sgr0
docker build -t filebeat1 ./Filebeat
echo "\033[32m Создание Docker-образа Filebeat успешно завершено"
tput sgr0
docker run -d --name filebeat --network=host -v /var/log/nginx:/var/log/nginx filebeat1
echo "\033[32m Docker-контейнер Filebeat запущен успешно"
tput sgr0
sleep 3
echo "\033[36m Скрипты Репликации и Бэкапа"
tput sgr0
echo "\033[33m Ожидание выполнения скриптов для MySQL"
tput sgr0
sleep 60
bash /root/proj/MySQL/repl.sh
echo "\033[32m Скрипт репликации MySQL выполнен успешно"
tput sgr0
sleep 3
echo "\033[32m Аварийное восстановление микросервисной архитектуры успешно завершено"
tput sgr0
