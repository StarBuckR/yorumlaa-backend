class Rating < ApplicationRecord
    belongs_to :user
    belongs_to :product

    #serialize :rating_category_names, Array
    #serialize :rating_values, Array

    validates :user_id, presence: true
    validates :product_id, presence: true

    validates :ratings, presence: true

    HUMANIZED_ATTRIBUTES = {
        user_id: "Kullanıcı ID'si",
        product_id: "Ürün ID'si",
        ratings: "Derecelendirmeler"
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
end
