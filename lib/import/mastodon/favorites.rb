class Import::Mastodon::Favorites < Import::Base
  def import_message
    "Importing favorites..."
  end

  def should_skip_import?
    local_account_ids.empty?
  end

  def perform_import
    result = database.connection.exec(
      "SELECT * FROM favourites WHERE account_id IN (#{in_clause(local_account_ids)}) ORDER BY id"
    )

    result.each { |row| import_favorite(row) }
  end

  private

  def import_favorite(row)
    new_account_id = id_mapper.get(:accounts, row['account_id'])
    new_post_id = id_mapper.get(:posts, row['status_id'])

    unless new_account_id && new_post_id
      @skipped += 1
      return
    end

    return if Favorite.exists?(account_id: new_account_id, post_id: new_post_id)

    Favorite.create!(
      account_id: new_account_id,
      post_id: new_post_id,
      created_at: row['created_at'],
      updated_at: row['updated_at']
    )

    @count += 1
    print_progress(50)
  end
end
