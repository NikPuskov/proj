# proj
Проектная работа

Аварийное восстановление микросервисной архитектуры

Проект разбит на микросервисы в контейнерах docker, каждая папка это отдельный образ контейнера с файлами конфигураций

Для запуска необходимо выполнить несколько пунктов

1. Необходимо предварительно:

   Установить Ubuntu 22.04

   Установить docker (sudo apt install docker.io)

   Запустить сервис docker (sudo systemctl enable --now docker)

   Установить git (sudo apt install git)

4. Клонировать репозиторий из GitHub (git clone https://github.com/NikPuskov/proj.git) b и перейти в папку proj (cd proj)

5. Nginx
   
   Создание образа (sudo docker build -t nginx1 ./Nginx)

   Запуск контейнера (sudo docker run -d --name nginx -p 80:80 -v /var/log/nginx:/var/log/nginx nginx1)

6. Apache

   Создание образа (sudo docker build -t httpd1 ./Httpd)

   Запуск контейнера (sudo docker run -d --name httpd -p 8080:8080 httpd1)

   
