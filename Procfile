sqlproxy: ./cloud_sql_proxy -instances=${GCLOUD_CLOUD_SQL}=tcp:3306 -credential_file=config/gcs.json -ip_address_types=PRIVATE
redis: redis-server
sidekiq: bundle exec sidekiq
app: bundle exec rails server -p 80