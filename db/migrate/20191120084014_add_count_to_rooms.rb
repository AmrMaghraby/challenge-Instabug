class AddCountToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :count, :integer
  end
end
