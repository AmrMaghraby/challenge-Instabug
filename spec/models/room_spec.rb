require 'rails_helper'

RSpec.describe Room, type: :model do
   it{ is_expected.to have_many(:room_messages) }
   it{ is_expected.to validate_presence_of :name }
   it{ is_expected.to validate_presence_of :app_token }
end
