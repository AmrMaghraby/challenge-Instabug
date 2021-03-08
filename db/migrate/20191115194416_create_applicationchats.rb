class CreateApplicationchats < ActiveRecord::Migration[5.2]
  def change
    create_table :applicationchats do |t|

      t.timestamps
    end
  end
end
