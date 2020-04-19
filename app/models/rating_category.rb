class RatingCategory < ApplicationRecord
    
    validates :category_name, presence: true, length: { minimum: 3, maximum: 20 }
end
