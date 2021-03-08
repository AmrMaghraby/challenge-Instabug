class DropColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :apps, :app_id
    remove_column :apps, :user_id
    remove_column :apps, :room_id
  end
end
