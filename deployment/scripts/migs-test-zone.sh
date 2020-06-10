#!/bin/bash
PROJECT_URL_PROTOCOL=$1
PROJECT_URL_DOMAIN=$2
PROJECT_URL_API='/zone'

set -e

echo "URL Destination: ${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}${PROJECT_URL_API}"
for ((i=1;i<=300;i++))
do
  curl -v --header "Connection: keep-alive" "${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}${PROJECT_URL_API}"
  sleep 2
  echo " "
done