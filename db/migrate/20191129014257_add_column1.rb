class AddColumn1 < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :room_id, :int
  end
end
