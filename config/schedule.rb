set :output, "#{path}/log/cron_log.log"
set :environment, "development"

every 1.minutes do
  runner "Room.chat_count_updater"
  runner "Room.message_count_updater"
  #command "echo 'hello' "
end