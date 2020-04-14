class UserCommentDetail < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :comment_id, presence: true
  validates :user_id, presence: true
  validates_inclusion_of :like, in: [true, false]
end
