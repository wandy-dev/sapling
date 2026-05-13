class Account < ApplicationRecord
  belongs_to :user, optional: true
  has_many :memberships
  has_many :communities, through: :memberships
  has_many :posts
  has_one_attached :avatar
  has_one_attached :header

  def member_of?(community_id)
    memberships.exists?(community_id: community_id)
  end

  def all_communities
    communities.to_a
  end

  def post_count
    self.posts.original_post.count
  end

  def following
    0
  end

  def followers
    0
  end
end
