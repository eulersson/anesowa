#!/bin/bash

# Runs an InfluxDB service so the rest of moduels (distributor, journal) can connect to
# it as clients to write and read data.
#
# Reference:
#
# - Section: Custom Initialization Scripts (https://hub.docker.com/_/influxdb)
#

# TODO: Use secret somehow.
INFLUX_DB_PASSWORD=${INFLUX_DB_PASSWORD:-ufftQDZNDESRALXi5NbS}
INFLUX_DB_DATA_PATH=${INFLUX_DB_DATA_PATH:-/influx_db/data}
INFLUX_DB_CONFIG_PATH=${INFLUX_DB_CONFIG_PATH:-/influx_db/config}
INFLUX_DB_CONTAINER_NAME=${INFLUX_DB_CONTAINER_NAME:-influx-db-server}
INFLUX_DB_SERVER_DOCKER_IMAGE=${INFLUX_DB_SERVER_DOCKER_IMAGE:-influxdb:2.7.4-alpine}
INFLUX_DB_TOKEN=${INFLUX_DB_TOKEN:-no_token}

if [[ "$(docker ps -aq --filter name=$INFLUX_DB_CONTAINER_NAME)" = "" ]]; then
  echo Container $INFLUX_DB_CONTAINER_NAME does not exist, creating a new one.
  set -x;
  docker run \
    --publish 8086:8086 \
    --volume $INFLUX_DB_DATA_PATH:/var/lib/influxdb2 \
    --volume $INFLUX_DB_CONFIG_PATH:/etc/influxdb2 \
    --env DOCKER_INFLUXDB_INIT_MODE=setup \
    --env DOCKER_INFLUXDB_INIT_USERNAME=anesowa \
    --env DOCKER_INFLUXDB_INIT_PASSWORD=$INFLUX_DB_PASSWORD \
    --env DOCKER_INFLUXDB_INIT_ORG=anesowa \
    --env DOCKER_INFLUXDB_INIT_BUCKET=anesowa \
    --env DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=$INFLUX_DB_TOKEN \
    --name $INFLUX_DB_CONTAINER_NAME \
    $INFLUX_DB_SERVER_DOCKER_IMAGE
  set +x;
else
  echo Container $INFLUX_DB_CONTAINER_NAME already exists, starting instead of creating a new one.
  set -x;
  docker start --attach $INFLUX_DB_CONTAINER_NAME
  set +x;
fi
