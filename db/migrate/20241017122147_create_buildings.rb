class CreateBuildings < ActiveRecord::Migration[7.2]
  def change
    create_table :buildings do |t|
      t.string :address
      t.string :state, limit: 2
      t.string :zip_code
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
