FROM ruby:2.6.6-alpine

LABEL maintainer="Uchiha Itachi <itachi@agate.id>"

ARG build_env
ARG master_key
ARG GCP_MIGS_NAME
ARG GCP_MIGS_REGION
ARG GCP_SQL_NAME
ARG version

ENV RAILS_ENV=${build_env} \
    RAILS_MASTER_KEY=${master_key} \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin \
    GCLOUD_MIGS_NAME=${GCP_MIGS_NAME} \
    GCLOUD_MIGS_REGION=${GCP_MIGS_REGION} \
    GCLOUD_CLOUD_SQL=${GCP_SQL_NAME} \
    APP_VERSION=${version} \
    RELEASE_VERSION=1.0.4 \
    SHELL=/bin/bash

WORKDIR /app
COPY . .

RUN apk --update --no-cache add build-base nodejs mysql-dev curl python3 py3-pip wget redis \
  && gem install bundler --no-document \
  && gem install foreman --no-document \
  && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
  && chmod +x ./cloud_sql_proxy \
  && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm -rf /var/cache/apk/* \
  && bundle install --deployment --jobs 10 --retry 5 \
  && bundle exec rails assets:precompile \
  && apk add --update bash g++ make curl \
  && curl -o /tmp/stress-${RELEASE_VERSION}.tgz https://fossies.org/linux/privat/stress-${RELEASE_VERSION}.tar.gz \
  && cd /tmp && tar xvf stress-${RELEASE_VERSION}.tgz && rm /tmp/stress-${RELEASE_VERSION}.tgz \
  && cd /tmp/stress-${RELEASE_VERSION} \
  && ./configure && make -j$(getconf _NPROCESSORS_ONLN) && make install \
  && apk del g++ make curl \
  && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

EXPOSE 80
CMD ["sh", "-c", "foreman start"]
