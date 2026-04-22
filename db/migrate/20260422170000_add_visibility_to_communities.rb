class AddVisibilityToCommunities < ActiveRecord::Migration[8.1]
  def change
    add_column :communities, :visibility, :integer, default: 0, null: false
    add_index :communities, :visibility
  end
end