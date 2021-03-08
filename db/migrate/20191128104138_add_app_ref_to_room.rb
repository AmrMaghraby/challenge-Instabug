class AddAppRefToRoom < ActiveRecord::Migration[5.2]
  def change
    add_reference :rooms, :app, foreign_key: true
  end
end
