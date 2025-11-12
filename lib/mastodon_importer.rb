require "open-uri"

class MastodonImporter
  attr_reader :backup_path, :mastodon_database, :id_maps

  def initialize(backup_path)
    @backup_path = backup_path
    @mastodon_database = MastodonDatabase.new(backup_path)
    @id_maps = {
      users: {},
      accounts: {},
      posts: {}
    }
  end

  def run
    import_users
    import_accounts
    import_posts
    import_favorites
    import_attachments
  ensure
    mastodon_database.cleanup_tmp_database
  end

  private

  def import_users
    puts "\n→ Importing users..."

    result = mastodon_database.connection.exec("SELECT * FROM users ORDER BY id")
    count = 0

    return if User.first.present?
    result.each do |row|
      user = User.new(
        email: row['email'],
        encrypted_password: row['encrypted_password'],
        remember_created_at: row['remember_created_at'],
        created_at: row['created_at'],
        updated_at: row['updated_at']
      )
      user.save(validate: false)

      @id_maps[:users][row['account_id'].to_i] = user.id
      count += 1
      print "\r  Imported #{count} users..." if count % 10 == 0
    end

    puts "\r  ✓ Imported #{count} users"
  end

  def import_accounts
    puts "\n→ Importing accounts (local only)..."

    # Only import accounts that have a user_id (local accounts)
    result = mastodon_database.connection.exec(
      "SELECT * FROM accounts WHERE domain IS NULL ORDER BY id"
    )
    count = 0

    result.each do |row|
      new_user_id = @id_maps[:users][row['id'].to_i]

      unless new_user_id
        puts "\n  ⚠ Skipping account #{row['id']} - user_id #{new_user_id} not found"
        next
      end

      account = Account.create!(
        username: row['username'],
        user_id: new_user_id,
        display_name: row['display_name'],
        bio: row['note'], # Mastodon uses 'note' for bio
        created_at: row['created_at'],
        updated_at: row['updated_at']
      )

      @id_maps[:accounts][row['id'].to_i] = account.id
      count += 1
      print "\r  Imported #{count} accounts..." if count % 10 == 0
    end

    puts "\r  ✓ Imported #{count} accounts"
  end

  def import_posts
    puts "\n→ Importing posts (from local accounts only)..."

    # Only import statuses from accounts we've imported
    local_account_ids = mastodon_database.connection.exec(
      "SELECT id FROM accounts WHERE domain IS NULL"
    ).map { |row| row['id'] }

    return puts "  ✓ No posts to import" if local_account_ids.empty?

    result = mastodon_database.connection.exec(
      "SELECT * FROM statuses WHERE account_id IN (#{local_account_ids.join(',')}) ORDER BY id"
    )
    count = 0
    posts_needing_reply_update = []

    result.each do |row|
      old_account_id = row['account_id'].to_i
      new_account_id = @id_maps[:accounts][old_account_id]

      unless new_account_id
        puts "\n  ⚠ Skipping post #{row['id']} - account_id #{old_account_id} not found"
        next
      end

      # Extract text content from Mastodon's status
      body = row['text'] || row['content'] || ''

      post = Post.create!(
        account_id: new_account_id,
        body: body,
        in_reply_to_id: nil, # We'll update this later
        created_at: row['created_at'],
        updated_at: row['updated_at']
      )

      @id_maps[:posts][row['id'].to_i] = post.id

      # Track posts that have replies for later update
      if row['in_reply_to_id']
        posts_needing_reply_update << {
          post_id: post.id,
          old_reply_to_id: row['in_reply_to_id'].to_i
        }
      end

      count += 1
      print "\r  Imported #{count} posts..." if count % 50 == 0
    end

    puts "\r  ✓ Imported #{count} posts"

    # Update in_reply_to_id references
    if posts_needing_reply_update.any?
      puts "  → Updating reply references..."
      updated = 0

      posts_needing_reply_update.each do |item|
        new_reply_to_id = @id_maps[:posts][item[:old_reply_to_id]]
        if new_reply_to_id
          Post.where(id: item[:post_id]).update_all(in_reply_to_id: new_reply_to_id)
          updated += 1
        end
      end

      puts "  ✓ Updated #{updated} reply references"
    end
  end

  def import_favorites
    puts "\n→ Importing favorites..."

    # Only import favourites for accounts and statuses we've imported
    local_account_ids = mastodon_database.connection.exec(
      "SELECT id FROM accounts WHERE domain IS NULL"
    ).map { |row| row['id'] }

    return puts "  ✓ No favorites to import" if local_account_ids.empty?

    result = mastodon_database.connection.exec(
      "SELECT * FROM favourites WHERE account_id IN (#{local_account_ids.join(',')}) ORDER BY id"
    )
    count = 0
    skipped = 0

    result.each do |row|
      old_account_id = row['account_id'].to_i
      old_status_id = row['status_id'].to_i

      new_account_id = @id_maps[:accounts][old_account_id]
      new_post_id = @id_maps[:posts][old_status_id]

      unless new_account_id && new_post_id
        skipped += 1
        next
      end

      # Check if favorite already exists
      next if Favorite.exists?(account_id: new_account_id, post_id: new_post_id)

      Favorite.create!(
        account_id: new_account_id,
        post_id: new_post_id,
        created_at: row['created_at'],
        updated_at: row['updated_at']
      )

      count += 1
      print "\r  Imported #{count} favorites..." if count % 50 == 0
    end

    puts "\r  ✓ Imported #{count} favorites"
    puts "  ⚠ Skipped #{skipped} favorites (referenced non-local content)" if skipped > 0
  end

  def import_attachments
    puts "\n→ Importing attachments..."

    # Only import favourites for accounts and statuses we've imported
    local_account_ids = mastodon_database.connection.exec(
      "SELECT id FROM accounts WHERE domain IS NULL"
    ).map { |row| row['id'] }

    return puts "  ✓ No attachments to import" if local_account_ids.empty?

    local_status_ids = mastodon_database.connection.exec(
      "SELECT id FROM statuses WHERE account_id IN (#{local_account_ids.join(',')}) ORDER BY id"
    ).map { |row| row['id'] }

    return puts "  ✓ No attachments to import" if local_account_ids.empty?

    result = mastodon_database.connection.exec(
      "SELECT * FROM media_attachments WHERE status_id IN (#{local_status_ids.join(',')}) ORDER BY id"
    )
    count = 0
    skipped = 0

    result.each do |row|
      old_status_id = row['status_id'].to_i

      new_post_id = @id_maps[:posts][old_status_id]

      unless new_post_id
        skipped += 1
        next
      end

      post = Post.find(new_post_id)

      attachment_url = S3Helper.construct_mastodon_url(filename: row['file_file_name'], id: row['id'])
      post.attachments.attach(io: URI.open(attachment_url), filename: row['file_file_name'])

      count += 1
      print "\r  Imported #{count} favorites..." if count % 50 == 0
    end

    puts "\r  ✓ Imported #{count} attachments"
    puts "  ⚠ Skipped #{skipped} attachments (referenced non-local content)" if skipped > 0
  end
end
