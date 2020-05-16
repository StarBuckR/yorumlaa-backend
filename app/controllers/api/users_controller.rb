class API::UsersController < ApplicationController
    #def index
        #render json: { msg: session[:user_id] }, status: :ok
    #    if request.headers["authorization"]
    #        user = JWT.decode request.headers["authorization"], Rails.application.secrets.secret_key_base, true, { algorith: 'HS256' }
    #        render json: user, status: :ok
    #    else
    #        render_not_logged_in
    #    end
    #end

    def create
        user = User.new(user_params) # create new user
        if user.save # try to save user
            render json: user.to_json(only: [:id, :username]), status: 200 # if saved, print id and username
        else 
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity # if not saved, display errors
        end
        byebug
    end

    def update
        user = User.find_by(id: params[:id]) # find user by id on the url
        if user && user.authenticate(params[:user][:password]) # if user is exists and password is correct
            user.update(password: params[:user][:new_password]) # update password with new password
            if user.save # try to save user
                render json: user.to_json(only: [:id, :username]) , status: :ok # if saved, display id and username
            else 
                render json: { errors: user.errors.full_messages }, status: 402 # if not saved, display errors
            end
        else
            render json: { message: "Hatalı şifre girdiniz" }, status: :unauthorized # if password is incorrect, display error
        end
    end

    def show
        @user = User.find_by(id: params[:id]) # find user by id on the url
        if @user # if user exists
            render :show, status: :ok # display id and username
        else # if not exists
            render json: { message: "Kullanıcı bulunamadı" }, status: 404 # display user not found
        end
    end

    def destroy
        user = User.find_by(id: params[:id]) # find user by id on the url
        if user && user.authenticate(params[:user][:password]) # if authenticated
            user.delete # delete user
            render json: { message: 'Hesabınız silindi!' }, status: :ok # display success message
        else # if not authenticated
            render json: { errors: user.errors.full_messages }, status: :unauthorized # display errors
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password, :avatar) # permit params under user
    end
end