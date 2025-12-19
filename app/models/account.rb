class Account < ApplicationRecord
  belongs_to :user
  has_many :posts
  has_one_attached :avatar
  has_one_attached :header

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
