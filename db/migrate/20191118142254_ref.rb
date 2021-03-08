class Ref < ActiveRecord::Migration[5.2]
  def change
  
    add_foreign_key App , Room
    
    
  end
end
