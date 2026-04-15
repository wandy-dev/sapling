class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one :account
  belongs_to :community
  has_many :memberships
  has_many :communities, through: :memberships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def finished_onboarding?
    self.account.present?
  end

  def member_of?(community_id)
    memberships.exists?(
      community_id: community_id
    ) || self.community_id == community_id
  end

  def all_communities
    (communities.to_a << community).uniq
  end
end
