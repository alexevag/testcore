#!/bin/bash
# Step 1: Create a directory for the MySQL Docker setup
mkdir -p mysql-docker
cd mysql-docker

# Step 2: Download the docker-compose.yaml file
wget https://raw.githubusercontent.com/datajoint/mysql-docker/master/docker-compose.yaml

# Step 3: Prompt the user for a password
echo -n "Enter the MySQL root password: "
read -s MYSQL_PASSWORD
echo

# Step 4: Modify the docker-compose.yaml file to include the password
awk -v password="$MYSQL_PASSWORD" '/MYSQL_ROOT_PASSWORD/ {print "      - MYSQL_ROOT_PASSWORD="password; next}1' docker-compose.yaml > docker-compose.temp.yaml
mv docker-compose.temp.yaml docker-compose.yaml

# Step 5: Run the Docker container in detached mode
docker-compose up -d

sleep 20

git clone https://github.com/ef-lab/EthoPy
cd EthoPy

# Step 5: Create the local_conf.json file with the entered password
echo "{
    \"database.host\": \"127.0.0.1\",
    \"database.user\": \"root\",
    \"database.password\": \"$MYSQL_PASSWORD\",
    \"database.port\": 3306,
    \"database.reconnect\": true,
    \"loglevel\": \"INFO\",
    \"database.enable_python_native_blobs\": true
}" > dj_local_conf.json

# # Additional Python commands
python3 -c 'from core.Experiment import *'
python3 -c 'from core.Stimulus import *'
python3 -c 'from core.Behavior import *'
python3 -c 'from Stimuli import *'
python3 -c 'from Behaviors import *'
python3 -c 'from Experiments import *'

cd .. 

rm -rf EthoPy