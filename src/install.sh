#!/bin/bash

# ref https://claudiu.psychlab.eu/post/homelab-3-install-configure-guacamole-as-docker-container/
# ref https://stackoverflow.com/a/66435966

# get db init file
sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > initdb.sql

# deploy guacamole
sudo docker compose up -d

# wait
sleep 5

# restore initdb.sql in to db
sudo docker exec -i guacamole_db sh -c 'mysql -u root --password=DBRootPSW -e "CREATE DATABASE IF NOT EXISTS guacamole_db"'
sudo docker exec -i guacamole_db sh -c 'exec mysql -u root --password=DBRootPSW guacamole_db' < initdb.sql

# wait
sleep 5

# display message
echo '===================================================='
echo "open browser goto http://$(hostname -I | awk '{print $1}'):8080/guacamole"
echo 'default username and default password is guacadmin'