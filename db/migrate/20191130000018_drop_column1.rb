class DropColumn1 < ActiveRecord::Migration[5.2]
  def change
        remove_column :apps, :created_at
        remove_column :apps, :updated_at



  end
end
