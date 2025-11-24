class Import::PostgresDatabase
  attr_reader :tmp_db_name, :backup_path

  def initialize(service, backup_path)
    @tmp_db_name = "#{service}_import_#{Time.now.to_i}"
    @backup_path = backup_path
    setup_tmp_database
    load_backup_into_tmp_db
  end

  def connection
    db_config = ActiveRecord::Base.connection_db_config.configuration_hash

    @temp_conn ||= PG.connect(
      host: db_config[:host] || 'localhost',
      port: db_config[:port] || 5432,
      user: "postgres",
      password: db_config[:password],
      dbname: tmp_db_name
    )
  end

  def setup_tmp_database
    puts "\n→ Creating temporary database..."

    postgres_connection.exec("CREATE DATABASE #{tmp_db_name}")
    postgres_connection.close

    puts "  ✓ Created database: #{tmp_db_name}"
  end

  def load_backup_into_tmp_db
    puts "\n→ Loading #{service.titleize} backup into temporary database..."
    db_config = ActiveRecord::Base.connection_db_config.configuration_hash

    cmd = [
      'pg_restore',
      '--no-owner',
      '--no-privileges',
      '-h', db_config[:host] || 'localhost',
      '-p', (db_config[:port] || 5432).to_s,
      '-U', "postgres",
      '-d', tmp_db_name,
      backup_path
    ].compact

    # Set password via environment variable
    env = {}
    env['PGPASSWORD'] = db_config[:password] if db_config[:password]

    system(env, *cmd)

    unless $?.success?
      raise "Failed to restore backup. Make sure pg_restore is installed and accessible."
    end

    puts "  ✓ Backup loaded successfully"
  end

  def cleanup_tmp_database
    return unless tmp_db_name

    puts "\n→ Cleaning up temporary database..."

    # Terminate connections to temp database
    postgres_connection.exec("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '#{tmp_db_name}'")
    postgres_connection.exec("DROP DATABASE IF EXISTS #{tmp_db_name}")
    postgres_connection.close

    puts "  ✓ Temporary database removed"
  rescue => e
    puts "  ⚠ Warning: Could not cleanup temp database: #{e.message}"
  end

  private

  def postgres_connection
    db_config = ActiveRecord::Base.connection_db_config.configuration_hash

    conn = PG.connect(
      host: db_config[:host] || 'localhost',
      port: db_config[:port] || 5432,
      user: 'postgres',
      password: db_config[:password],
      dbname: 'postgres'
    )
  end
end
