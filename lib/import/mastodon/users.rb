class Import::Mastodon::Users < Import::Base
  def import_message
    "Importing users..."
  end

  def should_skip_import?
    User.first.present?
  end

  def perform_import
    result = database.connection.exec("SELECT * FROM users ORDER BY id")

    result.each do |row|
      user = create_user(row)
      id_mapper.store(:users, row['account_id'], user.id)
      @count += 1
      print_progress
    end
  end

  private

  def create_user(row)
    user = User.new(
      email: row['email'],
      encrypted_password: row['encrypted_password'],
      remember_created_at: row['remember_created_at'],
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
    user.save(validate: false)
    user
  end
end
