class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.text :application

      t.timestamps
    end
  end
end
