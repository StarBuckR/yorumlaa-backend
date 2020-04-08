class API::SessionsController < ApplicationController
    
    def create
        user = User.find_by(username: params[:user][:username])
        if user && user.authenticate(params[:user][:password])
            session[:user_id] = user.id
            render json: { jwt: encode_token({id: user.id, username: user.username})}, status: :created
        else
            render json: {msg: 'Invalid credentials'}, status: :unauthorized
        end
    end

    def destroy
        session[:id] = nil
        render json: {msg: 'Session Destroyed'}, status: :ok
    end

    private

    def encode_token(payload={})
        exp = 24.hours.from_now
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
end