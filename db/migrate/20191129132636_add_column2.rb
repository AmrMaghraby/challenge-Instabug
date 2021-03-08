class AddColumn2 < ActiveRecord::Migration[5.2]
  def change
    add_column :room_messages, :room_meesage_id, :int
  end
end
