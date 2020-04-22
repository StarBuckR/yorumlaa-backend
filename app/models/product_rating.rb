class ProductRating < ApplicationRecord
    #serialize :category_names, Array
    
    validates :category_names, presence: true
    validates :product_id, presence: true

    HUMANIZED_ATTRIBUTES = {
        category_names: "Kategori ismi",
        product_id: "Ürün ID'si"
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
end
