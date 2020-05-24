class Product < ApplicationRecord
    has_many :comments
    has_many :ratings

    has_many_attached :images

    extend FriendlyId
    friendly_id :title, use: :slugged

    validates :title, presence: true, length: { maximum: 100 }, uniqueness: { case_sensitive: false }
    validates :approval, default: false

    HUMANIZED_ATTRIBUTES = {
        title: "Başlık",
        approval: "Onay"
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def self.search(search)
        where("title LIKE ?", "%#{search}%")
    end

    def self.category_search(search)
        where("category LIKE ?", "%#{search}%")
    end
end
