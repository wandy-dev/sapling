class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :community

  enum :role, { member: 0, admin: 1, owner: 2 }, default: :member

  validates :user, uniqueness: { scope: :community }
end
