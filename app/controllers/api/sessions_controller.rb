class API::SessionsController < ApplicationController
    def create
        user = User.where(username: params[:user][:email_or_username])
                .or(User.where(email: params[:user][:email_or_username])).first
        # find user by username or email

        if user && user.authenticate(params[:user][:password]) # if authenticated
            #session[:user_id] = user.id
            verified = false
            verified = true if user.verification.eql?("true")
            render json: { jwt: encode_token({id: user.id, username: user.username}), id: user.id, username: user.username, verification: verified}, 
                status: :created # render jwt token
        else # if not authenticated
            render json: { message: 'Kullanıcı adı, email veya şifre hatalı' }, 
                status: :unauthorized # render username, email or password invalid
        end
    end

    def destroy
        #session[:user_id] = nil
        render json: { message: 'Başarıyla çıkış yapıldı!' }, status: :ok # Display session destroyed
    end
end