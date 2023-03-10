class SimulateHighCpuLoadJob < ApplicationJob
  queue_as :default

  def perform
    puts 'SimulateHighCpuLoadJob triggered!'
    cmd = '/usr/local/bin/stress --cpu 64 --timeout 120'
    puts `#{cmd}`
  end
end
