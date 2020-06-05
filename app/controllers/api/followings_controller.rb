class API::FollowingsController < ApplicationController
    before_action :require_login, only: [:follow]

    def follow
        product = Product.friendly.find(params[:slug])
        user = current_user

        follow =  Following.new(user_id: user.id, product_id: product.id, update_notif: 1)

        if follow.save
            render json: follow, status: :created
        else
            render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def get_notifications
        follows = Following.where(user_id: current_user.id).all
        
        output = Hash.new()
        follows.each do |follow|
            product = Product.find_by(id: follow.product_id)
            output.merge!("#{product.title}": Comment.where(product_id: product.id).where('updated_at > ?', follow.updated_at).count)
            update_integer = 1
            if follow.update_notif > 0
                update_integer = 0
            end
            follow.update(update_notif: update_integer)
        end

        render json: output, status: :ok
    end

end