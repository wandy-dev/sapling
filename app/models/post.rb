class Post < ApplicationRecord
  belongs_to :account
  belongs_to :in_reply_to, class_name: 'Post', optional: true, dependent: :destroy

  has_many :replies,
           class_name: 'Post',
           foreign_key: 'in_reply_to_id',
           inverse_of: :in_reply_to,
           dependent: :destroy
  has_many :favorites

  has_many_attached :attachments

  scope :original_post, -> { where(in_reply_to: nil) }
end
