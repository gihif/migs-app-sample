class HomeController < ApplicationController
  def index
    cmd = "gcloud compute instance-groups managed list-instances #{ENV['GCLOUD_MIGS_NAME']} --region #{ENV['GCLOUD_MIGS_REGION']} --filter=\"NAME:$(hostname)\" --format=\"table(INSTANCE_TEMPLATE)\""
    @zone = `#{cmd}`.split("\n").last rescue 'command not found'

    cmd = "gcloud compute instance-groups managed list-instances #{ENV['GCLOUD_MIGS_NAME']} --region #{ENV['GCLOUD_MIGS_REGION']} --filter=\"NAME:$(hostname)\" --format=\"table(ZONE)\""
    @template = `#{cmd}`.split("\n").last rescue 'command not found'

    @hostname = %x{ hostname }
    @version = ''
    @current_load = ''
    @health_check = ''
  end
end
