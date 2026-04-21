class CreatePost
  include Interactor::Organizer

  organize BuildPost, CreateCommunityPosts, AttachPostMedia
end
