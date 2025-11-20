class AddCommunityIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :community, foreign_key: true
  end
end
