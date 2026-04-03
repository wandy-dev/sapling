class Post < ApplicationRecord
  belongs_to :account
  belongs_to :in_reply_to,
    class_name: 'Post', optional: true, dependent: :destroy
  has_many :replies,
           class_name: 'Post',
           foreign_key: 'in_reply_to_id',
           inverse_of: :in_reply_to,
           dependent: :destroy
  has_many :favorites
  has_many_attached :attachments
  has_many :community_posts
  has_many :communities, through: :community_posts

  # I need to choose how I want to handle references to user like the like
  # button before we can broadcast from the model so this is a future goal
  # after_create_commit do
  #   broadcast_prepend_to :posts, partial: "posts/post", locals: { post: self }
  # end

  scope :original_post, -> { where(in_reply_to: nil) }
  scope :community, ->(community) do
    if community.present?
      joins(:community_posts)
        .where(community_posts: { community: community })
    else
      Post.all
    end
  end
end
