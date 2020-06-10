#!/bin/bash
PROJECT_URL_PROTOCOL=$1
PROJECT_URL_DOMAIN=$2

for (( ; ; ))
do
  curl ${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}/zone
  sleep 2
done