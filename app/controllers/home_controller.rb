class HomeController < ApplicationController
  before_action :fetch_zone, only: [:index, :zone]
  before_action :fetch_template, only: [:index, :version]
  before_action :fetch_dbzone, only: [:index]
  before_action :fetch_dbstatus, only: [:index]

  def index
    @hostname = %x{ hostname }
    @version = ENV['APP_VERSION']
    @current_load = $REDIS.get('load_status').present? ? 'HIGH' : 'NORMAL'
    @health_check = $REDIS.get('unhealthy_status').present? ? 'UNHEALTHY' : 'HEALTHY'
  end

  def zone
    render plain: @zone
  end

  def version
    render plain: "app version: #{ENV['APP_VERSION']}\ntemplate: #{@template}"
  end

  def start_healthy
    $REDIS.del('unhealthy_status')
    redirect_to root_path
  end

  def start_unhealthy
    $REDIS.set('unhealthy_status', true)
    redirect_to root_path
  end

  def start_load
    SimulateHighCpuLoadJob.perform_later
    $REDIS.set('load_status', true)
    redirect_to root_path
  end

  private

  def fetch_zone
    cmd = "gcloud compute instance-groups managed list-instances #{ENV['GCLOUD_MIGS_NAME']} --region #{ENV['GCLOUD_MIGS_REGION']} --filter=\"NAME:$(hostname)\" --format=\"table(ZONE)\""
    @zone = `#{cmd}`.split("\n").last rescue 'command not found'
  end

  def fetch_template
    cmd = "gcloud compute instance-groups managed list-instances #{ENV['GCLOUD_MIGS_NAME']} --region #{ENV['GCLOUD_MIGS_REGION']} --filter=\"NAME:$(hostname)\" --format=\"table(INSTANCE_TEMPLATE)\""
    @template = `#{cmd}`.split("\n").last rescue 'command not found'
  end

  def fetch_dbzone
    cmd = "gcloud sql instances list --filter=\"NAME:#{ENV['GCLOUD_SQL_NAME']}\" --format=\"table(LOCATION)\""
    @dbzone = `#{cmd}`.split("\n").last rescue 'command not found'
  end

  def fetch_dbstatus
    cmd = "gcloud sql instances list --filter=\"NAME:#{ENV['GCLOUD_SQL_NAME']}\" --format=\"table(STATUS)\""
    @dbstatus = `#{cmd}`.split("\n").last rescue 'command not found'
  end

end
