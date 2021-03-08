require 'rails_helper'

RSpec.describe RoomMessage, type: :model do
    it{ is_expected.to validate_presence_of :message }
    it{ is_expected.to validate_presence_of :created_at }
    it{ is_expected.to validate_presence_of :updated_at }
    it{ belong_to :room}
    it{ belong_to :user}  
end
