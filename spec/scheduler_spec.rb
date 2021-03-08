#require "rails_helper"
#require "whenever"
#describe Whenever do
#  let(:whenever) do
#    Whenever::JobList.new(file: Rails.root.join("config", "schedule.rb").to_s)
#  end

#  it "schedules the sending of challenge submission digests" do
#    expect(whenever).to schedule_rake("Room.chat_count_updater")
#      .every(1.minutes)
#      .at("21:08 pm")
#  end
#end

require 'rails_helper'
require 'whenever'

describe 'Schedule' do
  it 'updates Room chat count updater' do
    expected_runner_and_enviroment = "bundle exec bin/rails runner -e development"
    expected_method_to_be_called = "Room.chat_count_updater"
    expected_output = "cron_log.log 2>&1"
    expect(cron_output).to include(expected_runner_and_enviroment)
    expect(cron_output).to include(expected_method_to_be_called)
    expect(cron_output).to include(expected_output)
  end

  it 'updates message chat count updater' do
    expected_runner_and_enviroment = "bundle exec bin/rails runner -e development"
    expected_method_to_be_called = "Room.message_count_updater"
    expected_output = "cron_log.log 2>&1"
    expect(cron_output).to include(expected_runner_and_enviroment)
    expect(cron_output).to include(expected_method_to_be_called)
    expect(cron_output).to include(expected_output)
  end
end


def cron_output
  Whenever::JobList.new(file: Rails.root.join("config", "schedule.rb").to_s).
                    generate_cron_output.
                    gsub(Dir.pwd, '')
end

