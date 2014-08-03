#!/bin/bash

MYSQL_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' mysql)
MYSQL_PORT=3306

docker run -t -d --name jira --link mysql:db -p 8080:8080 -e "CONTEXT_PATH=jira" -e "DATABASE_URL=mysql://jirausr:jellyfish@${MYSQL_IP}:${MYSQL_PORT}/jiradb" mooxavier/docker-jira
