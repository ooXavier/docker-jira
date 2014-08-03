#!/bin/bash

# Creates JIRA database and user
MYSQL_PORT=3306
PASSWORD=$1

mysql -uadmin -p${PASSWORD} -h${MYSQL_IP} -P${MYSQL_PORT} -e "CREATE USER 'jirausr'@'%' IDENTIFIED BY 'jellyfish'"
mysql -uadmin -p${PASSWORD} -h${MYSQL_IP} -P${MYSQL_PORT} -e "CREATE DATABASE jiradb CHARACTER SET utf8 COLLATE utf8_bin"
mysql -uadmin -p${PASSWORD} -h${MYSQL_IP} -P${MYSQL_PORT} -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX on jiradb.* TO 'jirausr'@'%' IDENTIFIED BY 'jellyfish'"
mysql -uadmin -p${PASSWORD} -h${MYSQL_IP} -P${MYSQL_PORT} -e "FLUSH PRIVILEGES"
