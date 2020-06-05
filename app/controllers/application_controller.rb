class ApplicationController < ActionController::API
    include ExceptionHandler

    helper_method :current_user, :logged_in?, :is_admin?, :render_not_logged_in,
                    :decode_token, :encode_token, :require_same_user, :require_admin,
                    :require_login, :user_logged_in?

    # require same user for related and wanted functions
    def require_same_user
        if !current_user
            render json: { message: "Bu işlemi gerçekleştirmek için kendinize ait olması gerekiyor" }, 
                            status: :unauthorized and return
        end
    end
    # require admin for related and wanted functions
    def require_admin
        if !is_admin?
            render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" }, 
                            status: :unauthorized and return
        end
    end
    # require login for related and wanted functions
    def require_login
        if !logged_in?
            render json: { message: "Bu işlemi gerçekleştirmek için giriş yapmanız gerekiyor" }, 
                            status: :unauthorized and return
        end
    end

    def current_user
        # I did it's controls in de decode_token and exception_handler.rb 
        # so don't have to control here with any if
        token = request.headers["authorization"]
        user = decode_token(token)
           
        user_id = user["id"]
        @current_user ||= User.find(user_id) if user_id
    end

    def user_logged_in?
        token = request.headers["Authorization"]
        !!token
    end
    # if logged in return true, else return false
    def logged_in?
        !!current_user
    end

    def is_admin?
        if current_user&.role == "admin"
            return true # if admin return true
        else
            return false # if not admin return false
        end
    end

    # if user is not logged in, render message that user needs to log in
    def render_not_logged_in 
        render json: { message: "Bu işlemi gerçekleştirmeniz için giriş yapmanız gerekiyor" }, 
                        status: :unauthorized
    end

    # decoding JWT token function, it basically gets token, if any error happens(expiration or verification), render errors
    def decode_token(token)
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        HashWithIndifferentAccess.new body

        rescue JWT::ExpiredSignature, JWT::VerificationError => e
            raise ExceptionHandler::ExpiredSignature, e.message
        rescue JWT::DecodeError, JWT::VerificationError => e
            raise ExceptionHandler::DecodeError, e.message
    end
    
    # encode token with payload, given expiration 24 hours from now
    def encode_token(payload={})
        exp = 24.hours.from_now
        payload[:exp] = exp.to_i
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
end