class SimulateHighCpuLoadJob < ApplicationJob
  queue_as :default

  def perform
    cmd = 'stress --cpu 8 --timeout 120'
    puts `#{cmd}`
  end
end
