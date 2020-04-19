class Product < ApplicationRecord
    has_many :comments
    has_many :ratings

    extend FriendlyId
    friendly_id :title, use: :slugged

    validates :title, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
    validates :approval, default: false
end