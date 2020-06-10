class HomeController < ApplicationController
  before_action :fetch_zone, only: [:index, :zone]
  before_action :fetch_template, only: [:index, :version]

  def index
    @hostname = %x{ hostname }
    @version = ENV['APP_VERSION']
    @current_load = Redis.new.get('load_status').present? ? 'HIGH' : 'NORMAL'
    @health_check = Redis.new.get('unhealthy_status').present? ? 'UNHEALTHY' : 'HEALTHY'
  end

  def zone
    render plain: @zone
  end

  def version
    render plain: "app version: #{ENV['APP_VERSION']}\ntemplate: #{@template}"
  end

  def start_healthy
    Redis.new.del('unhealthy_status')
    redirect_to root_path
  end

  def start_unhealthy
    Redis.new.set('unhealthy_status', true)
    redirect_to root_path
  end

  def start_load
    Redis.new.set('load_status', true)
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
end
