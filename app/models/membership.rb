class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :community

  enum :role, { member: 0, admin: 1, owner: 2 }, default: :member

  validates :account, uniqueness: { scope: :community }

  after_create_commit :clear_timeline_cache

  private

  def clear_timeline_cache
    Feed.new("timeline:account:#{account_id}:local").clear
  end
end
