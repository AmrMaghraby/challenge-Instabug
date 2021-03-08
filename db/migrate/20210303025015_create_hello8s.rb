class CreateHello8s < ActiveRecord::Migration[5.2]
  def change
    create_table :hello8s do |t|

      t.timestamps
    end
  end
end
