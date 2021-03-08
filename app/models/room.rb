class Room < ApplicationRecord
  has_many :room_messages, dependent: :destroy
  belongs_to :app,  inverse_of: :rooms
  validates :name,uniqueness: true, presence: true
  validates :app_token, presence: true 
  
  def self.chat_count_updater
      @apps = App.all
      @apps.each do |app|
        chat_count =  Room.where(:app_token => app.access_token)
        app.update_attributes count: chat_count.size
      end
  end  
  
  def self.message_count_updater
      @chats = Room.all
      @chats.each do |chat|
        message_count =  RoomMessage.where(:room_id => chat.id)
        chat.update_attributes count: message_count.size
      end
  end  
  trigger.after(:insert) do
     "UPDATE rooms SET room_id  = ( SELECT IFNULL(MAX(room_id), 0) + 1 FROM rooms WHERE app_id  = NEW.app_id );"
  end
  
end
