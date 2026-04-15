require "open-uri"

class Import::Mastodon
  attr_reader :backup_path, :mastodon_database, :id_mapper, :community
  cattr_accessor :currently_importing, default: false

  def initialize(backup_path)
    @backup_path = backup_path
    @mastodon_database = Import::PostgresDatabase.new("mastodon", backup_path)
    @id_mapper = Import::IdMapper.new
  end

  def run
    self.class.currently_importing = true
    community = Community.create(name: "default")
    @community=Community.find_by(name: "default")
    importers.map(&:import)
  ensure
    self.class.currently_importing = false
    mastodon_database.cleanup_tmp_database
  end

  private

  def importers
    [
      Import::Mastodon::Users.new(mastodon_database, id_mapper, @community),
      Import::Mastodon::Accounts.new(mastodon_database, id_mapper),
      Import::Mastodon::Posts.new(mastodon_database, id_mapper, @community),
      Import::Mastodon::Favorites.new(mastodon_database, id_mapper),
      Import::Mastodon::Attachments.new(mastodon_database, id_mapper)
    ]
  end
end
