require 'rails_helper'

RSpec.describe Feed, type: :model do
  let(:redis) { Redis.new }
  let(:key) { "test:feed:1" }

  before { redis.del(key) }
  after { redis.del(key) }

  describe "#fetch" do
    context "when cache is empty" do
      it "fetches from block and caches results" do
        feed = Feed.new(key)
        result = feed.fetch { [[1, Time.now.to_i], [2, Time.now.to_i]] }

        expect(result).to eq([1, 2])
        expect(redis.zrange(key, 0, -1)).to eq(["1", "2"])
      end
    end

    context "when cache exists" do
      before { redis.zadd(key, Time.now.to_i, 1) }

      it "returns cached values without calling block" do
        feed = Feed.new(key)
        block_called = false
        result = feed.fetch { block_called = true; [[99, Time.now.to_i]] }

        expect(result).to eq([1])
        expect(block_called).to be false
      end
    end

    context "when Redis errors" do
      before do
        allow(redis).to receive(:zrevrange).and_raise(Redis::BaseError.new("connection failed"))
      end

      it "falls back to block result" do
        feed = Feed.new(key)
        result = feed.fetch { [[1, Time.now.to_i]] }

        expect(result).to eq([1])
      end
    end
  end

  describe "#append" do
    let(:feed) { Feed.new(key) }

    it "adds id with timestamp to sorted set" do
      feed.append(1, 1_234_567_890)
      feed.append(2, 1_234_567_891)

      expect(redis.zrange(key, 0, -1, with_scores: true)).to eq([["1", 1_234_567_890], ["2", 1_234_567_891]])
    end

    it "trims to max size" do
      allow(feed).to receive(:trim).and_call_original
      feed.append(1, 1)

      expect(feed).to have_received(:trim)
    end
  end

  describe "#remove" do
    let(:feed) { Feed.new(key) }

    before { redis.zadd(key, Time.now.to_i, 1) }

    it "removes id from sorted set" do
      feed.remove(1)

      expect(redis.zrange(key, 0, -1)).to be_empty
    end
  end

  describe "#trim" do
    let(:feed) { Feed.new(key) }

    it "removes oldest entries beyond max size" do
      (Feed::MAX_CACHE_SIZE + 10).times { |i| redis.zadd(key, i, i) }

      feed.send(:trim)

      expect(redis.zcard(key)).to eq(Feed::MAX_CACHE_SIZE)
    end
  end
end
