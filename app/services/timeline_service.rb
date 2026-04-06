class TimelineService
  class << self
    def get_community_timeline(community, user = nil)
      cache = Feed.new(cache_key(community, user))
      cache.fetch { fetch_community_from_db(community, user) }
    end

    def append_post(post)
      if post.visibility_public?
        Feed.new("timeline:local").append(post.id, post.created_at.to_i)
      end

      post.communities.each do |community|
        Feed.new(visibility_community_only_key(community)).append(post.id, post.created_at.to_i)
        if post.visibility_public?
          Feed.new(visibility_public_key(community)).append(post.id, post.created_at.to_i)
        end
      end
    end

    def remove_post(post)
      Feed.new("timeline:local").remove(post.id)
      post.communities.each do |community|
        Feed.new(visibility_community_only_key(community)).remove(post.id)
        Feed.new(visibility_public_key(community)).remove(post.id)
      end
    end

    private

    def cache_key(community, user)
      return "timeline:local" if community.nil?
      user&.member_of?(community.id) ? visibility_community_only_key(community) : visibility_public_key(community)
    end

    def visibility_community_only_key(community)
      "timeline:community:#{community.id}:private"
    end

    def visibility_public_key(community)
      "timeline:community:#{community.id}:public"
    end

    def fetch_community_from_db(community, user)
      if community.nil?
        base_query = Post.original_post.order(created_at: :desc)
      else
        base_query = Post.original_post
                         .joins(:community_posts)
                         .where(community_posts: { community: community })
                         .order(created_at: :desc)
      end

      if user&.member_of?(community&.id) && community.present?
        base_query.pluck(:id, :created_at)
      else
        base_query.visibility_public.pluck(:id, :created_at)
      end.map { |id, created_at| [id, created_at.to_i] }
    end
  end
end
