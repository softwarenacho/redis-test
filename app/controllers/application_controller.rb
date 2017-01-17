class ApplicationController < ActionController::Base
  def index
    if request.post?
      @value = (params[:value] || 10).to_i
      # Perform the calculation of the fibonnaci in background
      SlowJob.perform_async("Luis",@value)
    end

    # Retrieve from Redis the last 10 calculations
    @bottom = redis.lrange("calcs",-10,-1).reverse
  end

  private
  def redis
    @redis ||= Redis.new
  end

end
