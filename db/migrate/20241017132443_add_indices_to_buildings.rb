class AddIndicesToBuildings < ActiveRecord::Migration[7.2]
  def change
    add_index :buildings, :state
    add_index :buildings, :zip_code
  end
end
