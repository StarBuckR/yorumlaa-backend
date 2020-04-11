class API::SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            #session[:user_id] = user.id
            render json: { jwt: encode_token({id: user.id, username: user.username})}, status: :created
        else
            render json: { message: 'Kullanıcı adı veya şifre hatalı' }, status: :unauthorized
        end
    end

    def destroy
        #session[:user_id] = nil
        render json: { message: 'Session Destroyed' }, status: :ok
    end
end