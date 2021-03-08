# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerRoomMessagesInsert < ActiveRecord::Migration[5.2]
  def up
    create_trigger("room_messages_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("room_messages").
        after(:insert) do
      "UPDATE room_messages SET room_meesage_id  = ( SELECT IFNULL(MAX(room_meesage_id), 0) + 1 FROM room_messages WHERE room_id  = NEW.room_id );"
    end
  end

  def down
    drop_trigger("room_messages_after_insert_row_tr", "room_messages", :generated => true)
  end
end
