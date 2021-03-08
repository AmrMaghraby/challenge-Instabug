$redis = Redis::Namespace.new("RailsChatTutorial", :redis => Redis.new(:host =>  ENV["REDIS_HOST"]))
