class Import::IdMapper
  def initialize
    @maps = Hash.new { |h, k| h[k] = {} }
  end

  def store(type, old_id, new_id)
    @maps[type][old_id.to_i] = new_id
  end

  def get(type, old_id)
    @maps[type][old_id.to_i]
  end
end
