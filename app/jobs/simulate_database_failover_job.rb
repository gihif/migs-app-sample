class SimulateDatabaseFailoverJob < ApplicationJob
  queue_as :default

  def perform
    puts 'SimulateDatabaseFailoverJob triggered!'
    cmd = "gcloud sql instances failover #{ENV['GCLOUD_SQL_NAME']} --async --quiet"
    puts `#{cmd}`
  end
end
