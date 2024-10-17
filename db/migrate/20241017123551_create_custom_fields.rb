class CreateCustomFields < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_fields do |t|
      t.text :value
      t.integer :value_type
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
