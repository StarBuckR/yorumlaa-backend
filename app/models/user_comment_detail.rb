class UserCommentDetail < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :comment_id, presence: true
  validates :user_id, presence: true
  validates_inclusion_of :like, in: [true, false]

  HUMANIZED_ATTRIBUTES = {
    comment_id: "Yorum ID'si",
    user_id: "Kullanıcı ID'si",
    like: "Detay"
  }

  def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
end
