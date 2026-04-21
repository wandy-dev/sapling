class EditPost
  include Interactor::Organizer

  organize UpdatePostAttributes, SyncPostCommunities, AttachPostMedia
end
