class TimelineService
  class << self
    def get_timeline(community, user = nil)
      if community.nil? && user.present?
        return Feed.new(user_local_key(user)).fetch do
          fetch_user_local_timeline(user)
        end
      end

      if user&.member_of?(community.id)
        Feed.new(visibility_community_only_key(community)).fetch do
          fetch_member_timeline(community)
        end
      else
        Feed.new(visibility_public_key(community)).fetch do
          fetch_public_timeline(community)
        end
      end
    end

    def append_post(post)
      post.communities.each do |community|
        Feed.new(
          visibility_community_only_key(community)
        ).append(post.id, post.created_at.to_i)

        if post.visibility_public?
          Feed.new(
            visibility_public_key(community)
          ).append(post.id, post.created_at.to_i)
        end
      end

      # TODO: replace inline with background job
      # fan out to all users local timelines
      User.joins(:community_memberships)
        .where(community_memberships: { community: post.communities })
        .distinct
        .each do |member|
          Feed.new(user_local_key(member)).append(post.id, post.created_at.to_i)
        end
    end

    def remove_post(post)
      post.communities.each do |community|
        Feed.new(visibility_community_only_key(community)).remove(post.id)
        Feed.new(visibility_public_key(community)).remove(post.id)
      end

      # TODO: replace inline with background job
      # fan out to all users local timelines
      User.joins(:community_memberships)
          .where(community_memberships: { community: post.communities })
          .distinct
          .each do |member|
            Feed.new(user_local_key(member)).remove(post.id)
          end
    end

    private

    def user_local_key(user)
      "timeline:user:#{user.id}:local"
    end

    def visibility_community_only_key(community)
      "timeline:community:#{community.id}:private"
    end

    def visibility_public_key(community)
      "timeline:community:#{community.id}:public"
    end

    def fetch_user_local_timeline(user)
      Post.original_post
          .joins(:community_posts)
          .where(community_posts: { community: user.all_communities })
          .order(created_at: :desc)
          .pluck(:id, :created_at).map do |id, created_at|
            [id, created_at.to_i]
          end
    end

    def fetch_public_timeline(community)
      # WARNING: result is cached under a SHARED key (all public users).
      # Do NOT add any user-specific filtering here. If you need per-user
      # results, you must use a per-user cache key instead.
      Post.original_post.visibility_public
          .joins(:community_posts)
          .where(community_posts: { community: community })
          .order(created_at: :desc)
          .pluck(:id, :created_at).map do |id, created_at|
            [id, created_at.to_i]
          end
    end

    def fetch_member_timeline(community)
      # WARNING: result is cached under a SHARED key (all private users).
      # Do NOT add any user-specific filtering here. If you need per-user
      # results, you must use a per-user cache key instead.
      Post.original_post
          .joins(:community_posts)
          .where(community_posts: { community: community })
          .order(created_at: :desc)
          .pluck(:id, :created_at).map do |id, created_at|
            [id, created_at.to_i]
          end
    end
  end
end
