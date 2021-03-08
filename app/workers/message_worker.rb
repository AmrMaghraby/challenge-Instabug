require 'sidekiq'

# If your client is single-threaded, we just need a single connection in our Redis connection pool
Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'x', :size => 1, :url => 'redis://redis:6379' }
end

class MessageWorker
  include Sidekiq::Worker

  def perform(room_id , user_id , newMessage )
    # Go will take over
  end
end


