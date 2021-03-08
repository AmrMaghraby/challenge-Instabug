class AddAccessTokenToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :access_token, :string
    add_index :apps, :access_token, unique: true
  end
end
