class AddCountToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :count, :integer
  end
end
