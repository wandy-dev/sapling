class Feed
  MAX_CACHE_SIZE = 200

  def initialize(key)
    @key = key
  end

  def fetch(&block)
    cached = redis.zrevrange(@key, 0, -1)
    return cached.map(&:to_i) if cached.any?

    ids_with_timestamps = block.call
    ids_with_timestamps.each { |id, ts| redis.zadd(@key, ts, id) }
    ids_with_timestamps.map(&:first)
  rescue Redis::BaseError => e
    Rails.logger.warn("Feed fetch failed for #{@key}: #{e.message}")
    block.call.map(&:first)
  end

  def append(id, timestamp)
    redis.zadd(@key, timestamp, id)
    trim
  rescue Redis::BaseError => e
    Rails.logger.warn("Feed append failed for #{@key}: #{e.message}")
  end

  def remove(id)
    redis.zrem(@key, id)
  rescue Redis::BaseError => e
    Rails.logger.warn("Feed remove failed for #{@key}: #{e.message}")
  end

  private

  def trim
    redis.zremrangebyrank(@key, 0, -(MAX_CACHE_SIZE + 1))
  end

  def redis
    @redis ||= Redis.new
  end
end
