class S3Helper
  def self.construct_mastodon_url(filename:, id:)
    # Partition the ID (groups of 3 digits)
    partitioned_id = id.to_s.scan(/.{3}/).join('/')

    "https://family-post-files.nyc3.digitaloceanspaces.com/family-post-files/media_attachments/files/#{partitioned_id}/original/#{filename}"
  end
end
