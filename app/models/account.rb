class Account < ApplicationRecord
  belongs_to :user
  has_many :posts

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
