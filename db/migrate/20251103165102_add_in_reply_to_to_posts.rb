class AddInReplyToToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :in_reply_to, foreign_key: { to_table: :posts }
  end
end
