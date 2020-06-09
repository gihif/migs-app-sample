FROM ruby:2.6.6-alpine

LABEL maintainer="Uchiha Itachi <itachi@agate.id>"

ARG build_env
ARG master_key
ARG GCLOUD_MIGS_NAME
ARG GCLOUD_MIGS_REGION
ARG GCLOUD_CLOUD_SQL

ENV RAILS_ENV=${build_env} \
    RAILS_MASTER_KEY=${master_key} \
    RAILS_LOG_TO_STDOUT=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin

WORKDIR /app
COPY . .
COPY config/database.yml.example config/database.yml

RUN apk --update --no-cache add build-base nodejs mysql-dev curl python \
  && gem install bundler --no-document \
  && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm -rf /var/cache/apk/* \
  && bundle install --deployment --jobs 10 --retry 5 \
  && bundle exec rails assets:precompile \

# INSTALL CLOUD SQL PROXY
RUN apt-get install -y wget unzip zip htop \
  && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
  && chmod +x cloud_sql_proxy \
  && ./cloud_sql_proxy -instances=${GCLOUD_CLOUD_SQL}=tcp:3306 -ip_address_types=PRIVATE

#TEMPORARY SCRIPT FOR TESTING CONNECTION TO CLOUD SQL
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm \
  && md5sum mysql57-community-release-el7-9.noarch.rpm \
  && rpm -ivh mysql57-community-release-el7-9.noarch.rpm \
  && apt-get install -y mysql

EXPOSE 80
CMD ["sh", "-c", "bundle exec rails server -p 80" ]
