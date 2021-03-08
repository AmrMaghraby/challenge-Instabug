class CreateHello4s < ActiveRecord::Migration[5.2]
  def change
    create_table :hello4s do |t|

      t.timestamps
    end
  end
end
