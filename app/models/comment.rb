class Comment < ApplicationRecord
  validates :content, presence: true, length: { maximum: 500,
                                                too_long: '500 characters in comment is the maximum allowed.' }

  belongs_to :user
  belongs_to :post
end
