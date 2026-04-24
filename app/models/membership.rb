class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum :role, { member: 0, admin: 1, owner: 2 }, default: :member

  validates :user, uniqueness: { scope: :community }

  after_create_commit :clear_timeline_cache

  private

  def clear_timeline_cache
    Feed.new("timeline:user:#{user_id}:local").clear
  end
end
