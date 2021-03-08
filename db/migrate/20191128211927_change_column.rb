class ChangeColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :apps, :id, :primary_key
  end
end
