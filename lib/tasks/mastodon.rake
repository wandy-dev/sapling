namespace :mastodon do
  desc "Import data from Mastodon backup (pg_dump -Fc format)"
  task :import, [:backup_path] => :environment do |t, args|
    unless args[:backup_path]
      puts "Usage: rake mastodon:import[/path/to/backup.dump]"
      exit 1
    end

    backup_path = args[:backup_path] || "./tmp/backup.dump"
    unless File.exist?(backup_path)
      puts "Error: Backup file not found at #{backup_path}"
      exit 1
    end

    require_relative '../mastodon_importer'

    puts "Starting Mastodon import from #{backup_path}"
    puts "WARNING: This will import users, accounts, posts, and favorites."
    puts "Press Ctrl+C to cancel, or Enter to continue..."
    STDIN.gets

    importer = MastodonImporter.new(backup_path)
    importer.run

    puts "\n✓ Import completed successfully!"
  rescue => e
    puts "\n✗ Import failed: #{e.message}"
    puts e.backtrace.join("\n")
    exit 1
  end
end
