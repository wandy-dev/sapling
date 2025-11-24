class Import::Mastodon::Attachments < Import::Base
  def import_message
    "Importing attachments..."
  end

  def should_skip_import?
    local_account_ids.empty? || local_status_ids.empty?
  end

  def perform_import
    result = database.connection.exec(
      "SELECT * FROM media_attachments WHERE status_id IN (#{in_clause(local_status_ids)}) ORDER BY id"
    )

    result.each { |row| import_attachment(row) }
  end

  private

  def local_status_ids
    @local_status_ids ||= database.connection.exec(
      "SELECT id FROM statuses WHERE account_id IN (#{in_clause(local_account_ids)}) ORDER BY id"
    ).map { |row| row['id'] }
  end

  def import_attachment(row)
    new_post_id = id_mapper.get(:posts, row['status_id'])

    unless new_post_id
      @skipped += 1
      return
    end

    post = Post.find(new_post_id)
    attach_file(post, row)

    @count += 1
    print_progress(50)
  end

  def attach_file(post, row)
    attachment_url = Import::Mastodon::S3Helper.mastodon_media_attachment_url(
      filename: row['file_file_name'],
      id: row['id']
    )
    post.attachments.attach(io: URI.open(attachment_url), filename: row['file_file_name'])
  end
end
