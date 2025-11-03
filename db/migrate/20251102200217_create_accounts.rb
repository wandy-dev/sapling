class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :display_name
      t.string :username
      t.text :bio
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
