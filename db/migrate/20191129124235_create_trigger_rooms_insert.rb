# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggerRoomsInsert < ActiveRecord::Migration[5.2]
  def up
    create_trigger("rooms_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("rooms").
        after(:insert) do
      "UPDATE rooms SET room_id  = ( SELECT IFNULL(MAX(room_id), 0) + 1 FROM rooms WHERE app_id  = NEW.app_id );"
    end
  end

  def down
    drop_trigger("rooms_after_insert_row_tr", "rooms", :generated => true)
  end
end
