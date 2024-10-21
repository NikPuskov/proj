# proj
Проектная работа

"Аварийное восстановление микросервисной архитектуры"

Проект разбит на микросервисы в контейнерах docker, каждая папка это отдельный образ контейнера с файлами конфигураций

Рекомендованная конфигурация виртуальной машины для выполнения работы - процессор 4 ядра, 8 гб ОЗУ, не менее 20 гб SSD-диск

Для запуска необходимо выполнить несколько пунктов

1. Необходимо предварительно:

   Установить Ubuntu 22.04

   Работу выполнять под root `sudo -i`

   Поставить обновления `apt update` `apt upgrade`

   Установить git, если он не установлен `apt install git`

   Клонировать репозиторий из GitHub `git clone https://github.com/NikPuskov/proj.git` и перейти в папку proj `cd proj`

   Запустить скрипт install.sh `sh ./install.sh`

   Запустить скрипт proj.sh `sh ./proj.sh` 

   Либо выполнять всё попунктно далее сo 2 пункта

3. Установить docker `apt install docker.io`

   Запустить сервис docker `systemctl enable --now docker`

   Установить git, если он не установлен `apt install git`

   Установить MySQL клиент `apt install mysql-client-core-8.0`

   Клонировать репозиторий из GitHub `git clone https://github.com/NikPuskov/proj.git` и перейти в папку proj `cd proj`

4. Nginx

   Предварительно скачиваем docker-образ `docker pull nginx:1.26`

   Создание образа с конфигом `docker build -t nginx1 ./Nginx`

   Запуск контейнера `docker run -d --name nginx --network=host -p 80:80 -v /var/log/nginx:/var/log/nginx nginx1`

   Apache

   Предварительно скачиваем docker-образ `docker pull httpd:2.4.62`

   Создание образа с конфигами `docker build -t httpd1 ./Httpd`

   Запуск контейнера `docker run -d --name httpd -p 8080:8080 -p 8081:8081 -p 8082:8082 httpd1`

   Проверить балансировщик `curl localhost | grep Welcome` либо в браузере ip_address `ctrl+f5`

5. MySQL

   Предварительно скачиваем docker-образ `docker pull mysql:8.0`

   Копируем файл .my.cnf в корень `cp /root/proj/.my.cnf /root/.my.cnf`

   Создание образа mysql slave с конфигом `docker build -t slave ./MySQL`

   Запуск контейнера mysql slave `docker run --name mysql-slave -p 3308:3306 -e MYSQL_ROOT_PASSWORD=superuser -d slave`

   Запуск контейнера mysql master `docker run -v /var/lib/mysql:/var/lib/mysql --name mysql-master -p 3305:3306 -e MYSQL_ROOT_PASSWORD=superuser -d mysql:8.0`

   Запуск скрипта репликации `bash ./MySQL/repl.sh`

   Зайти на Slave `mysql -h127.0.0.1 -P3308` -> `show databases;` -> `show replica status\G;` -> `exit`

   Зайти на Master `mysql -р127.0.0.1 -P3305` -> `show databases;` -> `create database My_db;`

   Зайти на Slave `mysql -h127.0.0.1 -P3308` -> `show databases;` -> `show replica status\G;` -> `exit`
   
7. Prometheus + node_exporter + Grafana

   Предварительно скачиваем docker-образы `docker pull prom/prometheus` `docker pull prom/node-exporter` `docker pull grafana/grafana`

   Создание образа Prometheus с конфигом `docker build -t prometheus ./Prometheus`

   Запуск контейнера Prometheus `docker run -d --name prometheus -p 9090:9090 prometheus`

   Запуск контейнера Node_exporter `docker run -d --name node_exporter -p 9100:9100 prom/node-exporter`

   Запуск контейнера Grafana `docker run -d --name grafana -p 3000:3000 grafana/grafana`

   Настройки Grafana:

      a) В браузере ip_address:3000 -> admin/admin

      b) connections -> data sources -> add new data source -> prometheus -> ip_address:9090 -> save and test

      c) dashboards -> import dashboard -> 1860 -> load

8. ELK

   Предварительно скачиваем docker-образы `docker pull elasticsearch:8.15.0` `docker pull logstash:8.15.0` `docker pull kibana:8.15.0` `docker pull elastic/filebeat:8.15.0`

   Создание образа Elasticsearch с конфигом `docker build -t elastic1 ./Elastic`
   
   Запуск контейнера Elasticsearch `docker run -d --name elastic --network=host -p 9200:9200 -p 9300:9300 elastic1`

   Создание образа Kibana с конфигом `docker build -t kibana1 ./Kibana`

   Запуск контейнера Kibana `docker run -d --name kibana --network=host -p 5601:5601 kibana1`

   Создание образа Logstash с конфигом `docker build -t logstash1 ./Logstash`

   Запуск контейнера Logstash `docker run -d --name logstash --network=host -p 5400:5400 logstash1`

   Создание образа Filebeat с конфигом `docker build -t filebeat1 ./Filebeat`

   Запуск контейнера Filebeat `docker run -d --name filebeat --network=host -v /var/log/nginx:/var/log/nginx filebeat1`

   Зайти на ip_address:5601 -> management -> stack management -> index management

   analytics -> discover -> create dataview -> name "Nginx" -> index pattern "weblog*" -> timestamp -> save dataview to kibana
