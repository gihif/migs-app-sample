FROM ruby:2.6.6-alpine

LABEL maintainer="Uchiha Itachi <itachi@agate.id>"

ARG build_env
ARG master_key
ARG GCP_MIGS_NAME
ARG GCP_MIGS_REGION
ARG GCP_SQL_NAME

ENV RAILS_ENV=${build_env} \
    RAILS_MASTER_KEY=${master_key} \
    RAILS_LOG_TO_STDOUT=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin \
    GCLOUD_MIGS_NAME=${GCP_MIGS_NAME} \
    GCLOUD_MIGS_REGION=${GCP_MIGS_REGION} \
    GCLOUD_CLOUD_SQL=${GCP_SQL_NAME}

WORKDIR /app
COPY . .

RUN apk --update --no-cache add build-base nodejs mysql-dev curl python \
  && gem install bundler --no-document \
  && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm -rf /var/cache/apk/* \
  && bundle install --deployment --jobs 10 --retry 5 \
  && bundle exec rails assets:precompile

# INSTALL CLOUD SQL PROXY
RUN apk add --no-cache wget \
  && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
COPY ./cloud_sql_proxy .
RUN chmod +x ./cloud_sql_proxy

EXPOSE 80
CMD ["sh", "-c", "./cloud_sql_proxy -instances=${GCLOUD_CLOUD_SQL}=tcp:3306 -credential_file=config/gcs.json -ip_address_types=PRIVATE & bundle exec rails server -p 80" ]
