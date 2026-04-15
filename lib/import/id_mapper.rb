class Import::IdMapper
  def store(type, old_id, new_id, source = 'mastodon')
    Import::IdMapping.create(source: source,
                             source_type: type.to_s,
                             source_id: old_id,
                             target_id: new_id)
  end

  def get(type, old_id, source = 'mastodon')
    Import::IdMapping.find_by(source: source,
                              source_type: type.to_s,
                              source_id: old_id)&.target_id
  end
end
