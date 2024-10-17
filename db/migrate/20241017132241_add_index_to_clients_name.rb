class AddIndexToClientsName < ActiveRecord::Migration[7.2]
  def change
    add_index :clients, :name
  end
end
