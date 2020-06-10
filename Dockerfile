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
    APP_VERSION=${version}

WORKDIR /app
COPY . .

RUN apk --update --no-cache add build-base nodejs mysql-dev curl python wget redis \
  && gem install bundler --no-document \
  && gem install foreman \
  && wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy \
  && chmod +x ./cloud_sql_proxy \
  && curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm -rf /var/cache/apk/* \
  && bundle install --deployment --jobs 10 --retry 5 \
  && bundle exec rails assets:precompile

EXPOSE 80
CMD ["sh", "-c", "foreman start"]
