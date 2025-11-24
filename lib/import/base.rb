class Import::Base
  attr_reader :database, :id_mapper, :count, :skipped

  def initialize(database, id_mapper)
    @database = database
    @id_mapper = id_mapper
    @count = 0
    @skipped = 0
  end

  def import
    puts "\n→ #{import_message}"

    return early_exit_message if should_skip_import?

    perform_import
    print_summary
  end

  protected

  def import_message
    raise NotImplementedError
  end

  def perform_import
    raise NotImplementedError
  end

  def should_skip_import?
    false
  end

  def early_exit_message
    puts "  ✓ No #{entity_name} to import"
  end

  def entity_name
    self.class.name.split("::").last.downcase
  end

  def print_summary
    puts "\r  ✓ Imported #{count} #{entity_name}"
    puts "  ⚠ Skipped #{skipped} #{entity_name} (referenced non-local content)" if skipped > 0
  end

  def print_progress(frequency = 10)
    print "\r  Imported #{count} #{entity_name}..." if count % frequency == 0
  end

  def local_account_ids
    @local_account_ids ||= database.connection.exec(
      "SELECT id FROM accounts WHERE domain IS NULL"
    ).map { |row| row['id'] }
  end

  def in_clause(ids)
    ids.join(',')
  end
end
