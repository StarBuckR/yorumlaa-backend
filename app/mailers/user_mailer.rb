class UserMailer < ApplicationMailer
    default from: 'yorumlaabusiness@gmail.com'
    
    def send_mail(user)
        mail(
            to: user.email,
            from: "yorumlaabusiness@gmail.com",
            delivery_method_options: { api_key: '1afca57d88b9441c16d70b0ef2d0eae0', secret_key: '987e2a6174ab1630f4c0f069bae52ce1', version: 'v3.1' },
            subject: "Email Onayı",
            body: "Onay kodunuz: #{user.verification}"
        )
    end
end
