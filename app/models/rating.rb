class Rating < ApplicationRecord
    belongs_to :user
    belongs_to :product

    validates :user_id, presence: true
    validates :product_id, presence: true
    validates :product_category_id, presence: true
    validates :rating_value, presence: true
    validates_numericality_of :rating_value, greater_than_or_equal_to: 0, 
    less_than_or_equal_to: 10, message: 'Derecelendirme 0 ile 10 arasında olmalıdır'
end
