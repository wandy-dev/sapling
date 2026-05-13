class MigrateMembershipsToAccount < ActiveRecord::Migration[8.1]
  def up
    # Add account_id column (nullable first)
    add_reference :memberships, :account, foreign_key: true

    # Copy data: for each membership, find the user's account
    Membership.find_each do |membership|
      user = User.find_by(id: membership.user_id)
      if user&.account
        membership.update!(account_id: user.account.id)
      else
        Rails.logger.warn "Membership #{membership.id}: user #{membership.user_id} has no account, skipping"
      end
    end

    # Make column non-nullable (all memberships should have accounts now)
    change_column_null :memberships, :account_id, false

    # Remove user_id column
    remove_column :memberships, :user_id
  end

  def down
    # Add back user_id column
    add_reference :memberships, :user, foreign_key: true

    # Copy data back: for each membership, find the user from account
    Membership.find_each do |membership|
      account = Account.find_by(id: membership.account_id)
      if account&.user
        membership.update!(user_id: account.user.id)
      end
    end

    # Make column non-nullable
    change_column_null :memberships, :user_id, false

    # Remove account_id column
    remove_column :memberships, :account_id
  end
end