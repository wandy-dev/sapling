class Import::Mastodon::Accounts < Import::Base
  def import_message
    "Importing accounts (local only)..."
  end

  def perform_import
    result = database.connection.exec(
      "SELECT * FROM accounts WHERE domain IS NULL ORDER BY id"
    )

    result.each do |row|
      next unless (new_user_id = id_mapper.get(:users, row['id']))

      account = create_account(row, new_user_id)
      attach_avatar(account, row) if row['avatar_file_name'].present?
      attach_header(account, row) if row['header_file_name'].present?

      id_mapper.store(:accounts, row['id'], account.id)
      @count += 1
      print_progress
    end
  end

  private

  def create_account(row, new_user_id)
    Account.create!(
      username: row['username'],
      user_id: new_user_id,
      display_name: row['display_name'],
      bio: row['note'],
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  end

  def attach_avatar(account, row)
    avatar_url = Import::Mastodon::S3Helper.mastodon_account_avatar_url(
      filename: row['avatar_file_name'],
      id: row['id']
    )
    account.avatar.attach(io: URI.open(avatar_url), filename: row['avatar_file_name'])
  end

  def attach_header(account, row)
    header_url = Import::Mastodon::S3Helper.mastodon_account_header_url(
      filename: row['header_file_name'],
      id: row['id']
    )
    account.header.attach(io: URI.open(header_url), filename: row['header_file_name'])
  end
end
