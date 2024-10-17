class AddNameToCustomFields < ActiveRecord::Migration[7.2]
  def change
    add_column :custom_fields, :name, :string
  end
end
