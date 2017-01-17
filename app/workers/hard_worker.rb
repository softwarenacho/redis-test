class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
    puts "HARD WORKER"
  end
end
