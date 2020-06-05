class UserMailer < ApplicationMailer
    default from: 'yorumlaabusiness@gmail.com'
    
    def send_mail(user)
        mail(
            to: user.email,
            from: "yorumlaabusiness@gmail.com",
            delivery_method_options: { api_key: ENV["API_KEY"], secret_key: ENV["SECRET_KEY"], version: 'v3.1' },
            subject: "Email Onayı",
            body: "Onay kodunuz: #{user.verification}"
        )
    end
end
