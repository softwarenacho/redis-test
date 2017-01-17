# Worker classes are normal ruby classes
class SlowJob
  # Just include the Mixin below and the perform_async method will be available
  include Sidekiq::Worker

  # Calculate the nth fibonnaci sequence number
  def fib(x)
    return 0 if x < 1
    x < 3 ? 1 : fib(x-1) + fib(x-2)
  end

  # Sidekiq has the same interface as resque, so we can call this method asynchronously by using SlowJob.perform_async
  # When #perform_async is called the arguments are serialized to a Redis queue and later our background job processor
  # will dequeue them and call the #perform method below with them
  def perform(name, number)
    time = Time.now
    # Recursive Fibonnaci of larger than 30 numbers can take a while
    result = fib(number)
    duration = Time.now - time

    text =  "Dear #{name} the Fibonacci value of #{number} is #{result} (#{"%.2f" % duration }) #{time.strftime("%F %T")}"

    # Put the results in a redis list so we can see them on the web interface at each new request
    redis.rpush "calcs", text
  end

  # Create a redis client
  def redis
    @redis ||= Redis.new
  end
end
