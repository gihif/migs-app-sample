#!/bin/bash
PROJECT_URL_PROTOCOL=$1
PROJECT_URL_DOMAIN=$2
PROJECT_URL_API='/dbinfo'

set -e

echo "URL Destination: ${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}${PROJECT_URL_API}"

i=0
while [ "$i" -le 100 ]; do
  curl --silent ${PROJECT_URL_PROTOCOL}${PROJECT_URL_DOMAIN}${PROJECT_URL_API}
  sleep 1
  echo " "

  i=$(( i + 1 ))
done