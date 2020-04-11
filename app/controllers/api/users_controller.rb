class API::UsersController < ApplicationController
    def index
        #render json: { msg: session[:user_id] }, status: :ok
        if request.headers["authorization"]
            user = JWT.decode request.headers["authorization"], Rails.application.secrets.secret_key_base, true, { algorith: 'HS256' }
            render json: user, status: :ok
        else
            render_not_logged_in
        end
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: user.to_json(only: [:id, :username]), status: 200
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        user = User.find_by(id: params[:id])
        if user && user.authenticate(params[:user][:password])
            user.update_attribute(:password, params[:user][:new_password])
            if user.save
                render json: user.to_json(only: [:id, :username]) , status: :ok
            else
                render json: { errors: user.errors.full_messages }, status: 402
            end
        else
            render json: { errors: user.errors.full_messages }, status: :unauthorized
        end
    end

    def show
        user = User.find_by(id: params[:id])
        if user
            render json: user.to_json(only: [:id, :username]), status: :ok
        else
            render json: { msg: "User not found" }, status: 404
        end
    end

    def destroy
        user = User.find_by(id: params[:id])
        if user && user.authenticate(params[:user][:password])
            user.delete
            render json: {msg: 'User deleted!'}, status: :ok
        else
            render json: { errors: user.errors.full_messages }, status: :unauthorized
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
end