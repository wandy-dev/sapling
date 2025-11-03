class Post < ApplicationRecord
  belongs_to :account
  belongs_to :in_reply_to, class_name: 'Post', optional: true
  has_many :replies,
           class_name: 'Post',
           foreign_key: 'in_reply_to',
           inverse_of: :in_reply_to

  scope :original_post, -> { where(in_reply_to: nil) }

end
