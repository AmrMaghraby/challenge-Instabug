class AddAppIdToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :app_id, :integer
  end
end
