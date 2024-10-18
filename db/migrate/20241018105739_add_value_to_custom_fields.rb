class AddValueToCustomFields < ActiveRecord::Migration[7.2]
  def change
    add_column :custom_fields, :value, :string
  end
end
