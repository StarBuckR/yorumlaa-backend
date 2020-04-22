class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :product

    has_many :user_comment_details

    validates :body, presence: true, length: { minimum: 1, maximum: 2000 }
    validates :product_id, presence: true
    validates :user_id, presence: true
    validates :username, presence: true

    HUMANIZED_ATTRIBUTES = {
        body: "Yorum",
        product_id: "Ürün ID'si",
        user_id: "Kullanıcı ID'si",
        username: "Kullanıcı adı"
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
end
