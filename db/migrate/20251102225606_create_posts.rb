class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.text :body
      t.references :account, foreign_key: true

      t.timestamps
    end
  end
end
