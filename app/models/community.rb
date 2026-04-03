class Community < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :users
  has_many :community_posts, dependent: :destroy
  has_many :posts, through: :community_posts
end
