class Import::Mastodon::S3Helper
  def self.mastodon_media_attachment_url(filename:, id:)
    # Partition the ID (groups of 3 digits)
    partitioned_id = id.to_s.scan(/.{3}/).join('/')

    "https://family-post-files.nyc3.digitaloceanspaces.com/family-post-files/media_attachments/files/#{partitioned_id}/original/#{filename}"
  end

  def self.mastodon_account_avatar_url(filename:, id:)
    # Partition the ID (groups of 3 digits)
    partitioned_id = id.to_s.scan(/.{3}/).join('/')

    "https://family-post-files.nyc3.digitaloceanspaces.com/family-post-files/accounts/avatars/#{partitioned_id}/original/#{filename}"
  end

  def self.mastodon_account_header_url(filename:, id:)
    # Partition the ID (groups of 3 digits)
    partitioned_id = id.to_s.scan(/.{3}/).join('/')

    "https://family-post-files.nyc3.digitaloceanspaces.com/family-post-files/accounts/headers/#{partitioned_id}/original/#{filename}"
  end
end
