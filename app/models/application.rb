class Application < ApplicationRecord
   has_many :room_messages, dependent: :destroy,
                           inverse_of: :room
 
end
