#!/bin/bash

apt install docker.io
systemctl enable --now docker
docker pull nginx:1.26
docker pull httpd:2.4.62
docker pull mysql:8.0
docker pull prom/prometheus
docker pull prom/node-exporter
docker pull grafana/grafana
docker pull elasticsearch:8.15.0
docker pull logstash:8.15.0
docker pull kibana:8.15.0
docker pull elastic/filebeat:8.15.0
apt install mysql-client-core-8.0
