class AddNameToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :name, :string
    add_index :apps, :name, unique: true
  end
end
