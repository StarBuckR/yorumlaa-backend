class CategoryTree < ApplicationRecord
    validates :current_category, presence: true, length: { minimum: 3, maximum: 30 }

end
