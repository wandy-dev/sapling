class SyncPostCommunities
  include Interactor

  def call
    return unless context.community_ids.present?

    selected = context.community_ids.map(&:to_i)
    context.post.community_posts.where.not(community_id: selected).destroy_all
    context.community_ids.each do |cid|
      CommunityPost.find_or_create_by!(post: context.post, community_id: cid)
    end
  end
end