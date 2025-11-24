class Import::Mastodon::Posts < Import::Base
  def initialize(database, id_mapper)
    super
    @reply_updates = []
  end

  def import_message
    "Importing posts (from local accounts only)..."
  end

  def should_skip_import?
    local_account_ids.empty?
  end

  def perform_import
    result = database.connection.exec(
      "SELECT * FROM statuses WHERE account_id IN (#{in_clause(local_account_ids)}) ORDER BY id"
    )

    result.each { |row| import_post(row) }
    update_reply_references
  end

  private

  def import_post(row)
    new_account_id = id_mapper.get(:accounts, row['account_id'])

    unless new_account_id
      @skipped += 1
      return
    end

    post = create_post(row, new_account_id)
    id_mapper.store(:posts, row['id'], post.id)

    track_reply_update(post.id, row['in_reply_to_id']) if row['in_reply_to_id']

    @count += 1
    print_progress(50)
  end

  def create_post(row, new_account_id)
    Post.create!(
      account_id: new_account_id,
      body: row['text'] || row['content'] || '',
      in_reply_to_id: nil,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )
  end

  def track_reply_update(post_id, old_reply_to_id)
    @reply_updates << { post_id: post_id, old_reply_to_id: old_reply_to_id.to_i }
  end

  def update_reply_references
    return if @reply_updates.empty?

    puts "  → Updating reply references..."
    updated = 0

    @reply_updates.each do |item|
      if (new_reply_to_id = id_mapper.get(:posts, item[:old_reply_to_id]))
        Post.where(id: item[:post_id]).update_all(in_reply_to_id: new_reply_to_id)
        updated += 1
      end
    end

    puts "  ✓ Updated #{updated} reply references"
  end
end
