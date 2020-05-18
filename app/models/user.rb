class User < ApplicationRecord
    has_secure_password
    
    has_one_attached :avatar

    has_many :comments
    has_many :user_comment_details
    has_many :ratings

    validates :username, uniqueness: { case_sensitive: false }, 
                presence: true, length: { maximum: 50 }

    before_save { self.email = email.downcase }
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :email, uniqueness: { case_sensitive: false },
                presence: true, format: { with: EMAIL_REGEX }

    PASSWORD_REGEX = /\A(?=.{6,40})(?=.*\d)(?=.*[a-z]|[A-Z])/i
    validates :password, on: :create, length: { minimum: 6, maximum: 30 }, 
            format: { with: PASSWORD_REGEX, message: "en az 1 rakam ve 1 harf içermelidir" }
                
    HUMANIZED_ATTRIBUTES = {
        email: "E-mail",
        username: "Kullanıcı adı",
        password: "Şifre"
    }
    
    def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
end
