# proj
Проектная работа

"Аварийное восстановление микросервисной архитектуры"

Проект разбит на микросервисы в контейнерах docker, каждая папка это отдельный образ контейнера с файлами конфигураций

Для запуска необходимо выполнить несколько пунктов

1. Необходимо предварительно:

   Установить Ubuntu 22.04

   Установить docker (sudo apt install docker.io)

   Запустить сервис docker (sudo systemctl enable --now docker)

   Установить git (sudo apt install git)

4. Клонировать репозиторий из GitHub (git clone https://github.com/NikPuskov/proj.git) и перейти в папку proj (cd proj)

5. Nginx
   
   Создание образа (sudo docker build -t nginx1 ./Nginx)

   Запуск контейнера (sudo docker run -d --name nginx --network=host -p 80:80 -v /var/log/nginx:/var/log/nginx nginx1)

6. Apache

   Создание образа (sudo docker build -t httpd1 ./Httpd)

   Запуск контейнера (sudo docker run -d --name httpd -p 8080:8080 -p 8081:8081 -p 8082:8082 httpd1)

7. MySQL

   Предварительно устанавливаем MySQL сервер (apt install mysql-server-8.0)

   Создание образа mysql slave (sudo docker build -t slave ./MySQL)

   Запуск контейнера mysql slave (sudo docker run --name mysql-slave -p 3308:3306 -e MYSQL_ROOT_PASSWORD=superuser -d slave)

   Запуск контейнера mysql master (sudo docker run --name mysql-master -p 3305:3306 -e MYSQL_ROOT_PASSWORD=superuser -d mysql:8.0)

   Запуск скрипта репликации (bash ./MySQL/repl.sh)

   Запуск скрипта backup посуточно (sudo cp ./MySQL/backup.sh /etc/cron.daily/backup.sh)

8. Prometheus + node_exporter + Grafana

   docker build -t prometheus ./Prometheus

   docker run -d --name prometheus -p 9090:9090 prometheus

   docker run -d --name grafana -p 3000:3000 grafana/grafana
