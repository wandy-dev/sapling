class AddCustomDomainToCommunities < ActiveRecord::Migration[8.1]
  def change
    add_column :communities, :custom_domain, :string
  end
end
