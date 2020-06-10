#!/bin/bash
PROJECT_URL_PROTOCOL=$1
PROJECT_URL_DOMAIN=$2

for i in {1..300}
do
  curl ${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}/zone
  sleep 2
done