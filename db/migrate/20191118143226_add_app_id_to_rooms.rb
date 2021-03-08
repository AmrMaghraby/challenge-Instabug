class AddAppIdToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :app_token, :string
  end
end
