class CreateHello2s < ActiveRecord::Migration[5.2]
  def change
    create_table :hello2s do |t|

      t.timestamps
    end
  end
end
