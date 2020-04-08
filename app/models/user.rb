class User < ApplicationRecord
    has_secure_password

    validates :username, uniqueness: { case_sensitive: false }, presence: true

    before_save { self.email = email.downcase }
    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :email, uniqueness: { case_sensitive: false },
                presence: true, format: { with: EMAIL_REGEX }

    PASSWORD_REGEX = /\A(?=.{6,40})(?=.*\d)(?=.*[a-z]|[A-Z])/i
    validates :password, presence: true, length: { minimum: 6 }, format: { with: PASSWORD_REGEX }
end
