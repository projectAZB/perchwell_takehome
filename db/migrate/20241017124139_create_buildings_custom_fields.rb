class CreateBuildingsCustomFields < ActiveRecord::Migration[7.2]
  def change
    create_table :buildings_custom_fields do |t|
      t.references :building, null: false, foreign_key: true
      t.references :custom_field, null: false, foreign_key: true

      t.timestamps
    end
  end
end
