class TimelineService
  class << self
    def get_timeline(community, account = nil)
      if community.nil? && account.present?
        return Feed.new(account_local_key(account)).fetch do
          fetch_account_local_timeline(account)
        end
      end

      if account&.member_of?(community.id)
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
      # fan out to all accounts local timelines
      Account.joins(:memberships)
        .where(memberships: { community: post.communities })
        .distinct
        .each do |account|
          Feed.new(account_local_key(account)).append(post.id, post.created_at.to_i)
        end
    end

    def remove_post(post, community_ids)
      community_ids.each do |community|
        Feed.new(visibility_community_only_key(community)).remove(post.id)
        Feed.new(visibility_public_key(community)).remove(post.id)
      end

      # TODO: replace inline with background job
      # fan out to all accounts local timelines
      Account.joins(:memberships)
          .where(memberships: { community: community_ids })
          .distinct
          .each do |account|
            Feed.new(account_local_key(account)).remove(post.id)
          end
    end

    private

    def account_local_key(account)
      "timeline:account:#{account.id}:local"
    end

    def visibility_community_only_key(community)
      id = community.respond_to?(:id) ? community.id : community

      "timeline:community:#{id}:private"
    end

    def visibility_public_key(community)
      id = community.respond_to?(:id) ? community.id : community

      "timeline:community:#{id}:public"
    end

    def fetch_account_local_timeline(account)
      Post.original_post
          .joins(:community_posts)
          .where(community_posts: { community: account.all_communities })
          .order(created_at: :desc)
          .pluck(:id, :created_at).map do |id, created_at|
            [id, created_at.to_i]
          end
    end

    def fetch_public_timeline(community)
      # WARNING: result is cached under a SHARED key (all public accounts).
      # Do NOT add any account-specific filtering here. If you need per-account
      # results, you must use a per-account cache key instead.
      Post.original_post.visibility_public
          .joins(:community_posts)
          .where(community_posts: { community: community })
          .order(created_at: :desc)
          .pluck(:id, :created_at).map do |id, created_at|
            [id, created_at.to_i]
          end
    end

    def fetch_member_timeline(community)
      # WARNING: result is cached under a SHARED key (all private accounts).
      # Do NOT add any account-specific filtering here. If you need per-account
      # results, you must use a per-account cache key instead.
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
