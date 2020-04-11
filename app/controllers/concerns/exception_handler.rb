module ExceptionHandler
    extend ActiveSupport::Concern
    
    class DecodeError < StandardError; end
    class ExpiredSignature < StandardError; end

    included do
      rescue_from ExceptionHandler::DecodeError do |_error|
        render json: {
          message: "Erişim reddedildi! Geçersiz token girildi."
        }, status: :unauthorized
      end
      rescue_from ExceptionHandler::ExpiredSignature do |_error|
        render json: {
          message: "Erişim reddedildi! Tokenin süresi doldu."
        }, status: :unauthorized
      end
    end

  end