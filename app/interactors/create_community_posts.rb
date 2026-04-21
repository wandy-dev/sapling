class CreateCommunityPosts
  include Interactor

  def call
    return unless context.community_ids.present?

    context.community_ids.each do |cid|
      CommunityPost.find_or_create_by!(post: context.post, community_id: cid)
    end
  end
end
