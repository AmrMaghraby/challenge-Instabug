namespace :es do
  desc "Build elastic index"
  task :build_index => :environment do
    RoomMessage.__elasticsearch__.create_index!
    RoomMessage.__elasticsearch__.refresh_index!
  end
end
