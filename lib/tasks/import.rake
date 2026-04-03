namespace :import do
  desc "Import data from Mastodon backup (pg_dump -Fc format)"
  task :mastodon, [:backup_path] => :environment do |t, args|
    backup_path = args[:backup_path] || "./tmp/import/mastodon/backup.dump"

    unless backup_path
      puts "Usage: rake mastodon:import[/path/to/backup.dump]"
      exit 1
    end

    unless File.exist?(backup_path)
      puts "Error: Backup file not found at #{backup_path}"
      exit 1
    end

    require_relative '../import/mastodon'

    importer = Import::Mastodon.new(backup_path)
    importer.run

    puts "\n✓ Import completed successfully!"
  rescue => e
    puts "\n✗ Import failed: #{e.message}"
    puts e.backtrace.join("\n")
    exit 1
  end
end
