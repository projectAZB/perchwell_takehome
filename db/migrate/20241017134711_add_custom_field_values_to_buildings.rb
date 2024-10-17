class AddCustomFieldValuesToBuildings < ActiveRecord::Migration[7.2]
  def change
    add_column :buildings, :custom_field_values, :jsonb, default: {}, null: false
  end
end
