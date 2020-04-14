class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :product

    has_many :user_comment_details

    validates :body, presence: true, length: { minimum: 1, maximum: 2000 }
    validates :product_id, presence: true
    validates :user_id, presence: true
    validates :username, presence: true
end
