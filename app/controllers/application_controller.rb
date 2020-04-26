class ApplicationController < ActionController::API
    include ExceptionHandler

    helper_method :current_user, :logged_in?, :is_admin?, :render_not_logged_in,
                    :decode_token, :encode_token, :require_same_user, :require_admin,
                    :require_login

    def require_same_user
        if !current_user
            render json: { message: "Bu işlemi gerçekleştirmek için kendinize ait olması gerekiyor" }, 
                            status: :unauthorized and return
        end
    end

    def require_admin
        if !is_admin?
            render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" }, 
                            status: :unauthorized and return
        end
    end

    def require_login
        if !logged_in?
            render json: { message: "Bu işlemi gerçekleştirmek için giriş yapmanız gerekiyor" }, 
                            status: :unauthorized and return
        end
    end

    def current_user
        # kontrolünü decode_token ve sonrasında exception_handler.rb 
        # içinde yaptığım için, if koymama gerek yok
        token = request.headers["authorization"]
        user = decode_token(token)
           
        user_id = user["id"]
        @current_user ||= User.find(user_id) if user_id
    end

    def logged_in?
        !!current_user
    end

    def is_admin?
        if current_user&.role == "admin"
            return true # eğer admin ise true döndürüyor
        else
            return false # eğer admin değil ise false döndürüyor
        end
    end

    def render_not_logged_in 
        render json: { msg: "Bu işlemi gerçekleştirmeniz için giriş yapmanız gerekiyor" }, 
                        status: :unauthorized
    end

    def decode_token(token)
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new body

        rescue JWT::ExpiredSignature, JWT::VerificationError => e
            raise ExceptionHandler::ExpiredSignature, e.message
        rescue JWT::DecodeError, JWT::VerificationError => e
            raise ExceptionHandler::DecodeError, e.message
    end
    
    def encode_token(payload={}) # encode token
        exp = 24.hours.from_now
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
end