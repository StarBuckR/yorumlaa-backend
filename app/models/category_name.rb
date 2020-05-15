class CategoryName < ApplicationRecord
    validates :category_name, presence: true, length: { minimum: 3, maximum: 30 },
        uniqueness: { case_sensitive: false }

    HUMANIZED_ATTRIBUTES = {
        category_name: "Kategori ismi",
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
end
