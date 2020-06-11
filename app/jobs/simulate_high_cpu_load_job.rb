class SimulateHighCpuLoadJob < ApplicationJob
  queue_as :default

  def perform
    cmd = '/usr/local/bin/stress --cpu 8'
    puts `#{cmd}` rescue 'command not found'
  end
end
