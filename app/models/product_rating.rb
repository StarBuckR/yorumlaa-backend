class ProductRating < ApplicationRecord
    #serialize :category_names, Array
    
    validates :category_names, presence: true
    validates :product_id, presence: true
end
