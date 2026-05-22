class CreateReply
  include Interactor::Organizer

  organize BuildPost, CreateCommunityPosts
end
