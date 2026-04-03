class CommunityPost < ApplicationRecord
  belongs_to :post
  belongs_to :community

  validates :post, uniqueness: { scope: :community }
end
