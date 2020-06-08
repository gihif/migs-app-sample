FROM ruby:2.6.6-alpine

LABEL maintainer="Uchiha Itachi <itachi@agate.id>"

ARG build_env
ARG master_key

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
  && bundle exec rails assets:precompile

EXPOSE 80
CMD ["sh", "-c", "bundle exec rails server -p 80" ]
