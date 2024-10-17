class DropBuildingsCustomFields < ActiveRecord::Migration[7.2]
  def change
    drop_table :buildings_custom_fields
  end
end
