class Rating < ApplicationRecord
    belongs_to :user
    belongs_to :product

    #serialize :rating_category_names, Array
    #serialize :rating_values, Array

    validates :user_id, presence: true
    validates :product_id, presence: true

    validates :ratings, presence: true
end
