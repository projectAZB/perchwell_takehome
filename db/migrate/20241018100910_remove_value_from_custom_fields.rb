class RemoveValueFromCustomFields < ActiveRecord::Migration[7.2]
  def change
    remove_column :custom_fields, :value
  end
end
