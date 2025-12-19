require "open-uri"

class Import::Mastodon
  attr_reader :backup_path, :mastodon_database, :id_mapper

  def initialize(backup_path)
    @backup_path = backup_path
    @mastodon_database = Import::PostgresDatabase.new("mastodon", backup_path)
    @id_mapper = Import::IdMapper.new
  end

  def run
    importers.map(&:import)
  ensure
    mastodon_database.cleanup_tmp_database
  end

  private

  def importers
    [
      Import::Mastodon::Users.new(mastodon_database, id_mapper),
      Import::Mastodon::Accounts.new(mastodon_database, id_mapper),
      Import::Mastodon::Posts.new(mastodon_database, id_mapper),
      Import::Mastodon::Favorites.new(mastodon_database, id_mapper),
      Import::Mastodon::Attachments.new(mastodon_database, id_mapper)
    ]
  end
end
