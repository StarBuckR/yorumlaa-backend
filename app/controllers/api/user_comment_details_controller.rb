class API::UserCommentDetailsController < ApplicationController
    before_action :is_logged_in, only: [:create, :update]
    before_action :set_details, only: [:update, :destroy]
    before_action :require_same_user, only: [:update, :destroy]
    before_action :create_controls, only:[:create]

    def index
        render json: { message: "Deneme" }, status: :ok
    end

    # like or dislike comment
    def create
        details = UserCommentDetail.new(details_params)
        if details.save
            render json: details, status: :created
        else
            render json: { errors: details.errors.full_messages }, status: :unprocessable_entity
        end
        if(params[:details][:like])
            Comment.find_by(id: params[:details][:comment_id]).increment!(:like)
        else
            Comment.find_by(id: params[:details][:comment_id]).increment!(:dislike)
        end
    end

    #update like
    def update
        previous = UserCommentDetail.find_by(id: @details.id).like
        like = params[:details][:like]
        if @details.update(like: like)
            render json: @details, status: :ok
        else
            render json: { errors: @details.errors.full_messages }, status: :unprocessable_entity
        end

        if previous
            Comment.find_by(id: params[:details][:comment_id]).decrement!(:like)
        else
            Comment.find_by(id: params[:details][:comment_id]).decrement!(:dislike)
        end

        if like
            Comment.find_by(id: params[:details][:comment_id]).increment!(:like)
        else
            Comment.find_by(id: params[:details][:comment_id]).increment!(:dislike)
        end
    end

    # revoke like or dislike
    def destroy
        if @details.like
            Comment.find_by(id: params[:details][:comment_id]).decrement!(:like)
        else
            Comment.find_by(id: params[:details][:comment_id]).decrement!(:dislike)
        end

        if @details
            @details.delete
            render json: { message: "Like başarı ile silindi" }, status: :unprocessable_entity
        end
    end

    private

    def details_params
        params.require(:details).permit(:comment_id, :user_id, :like)
    end

    def set_details
        @details = UserCommentDetail.find_by(user_id: current_user.id, comment_id: params[:details][:comment_id])
        if !@details
            render json: { message: "Detay bulunamadı" }, status: :unprocessable_entity
        end
    end

    def create_controls
        details = UserCommentDetail.find_by(user_id: current_user.id)
        if details && details.comment_id == params[:details][:comment_id]
            render json: { message: "Yeniden like oluşturamazsınız, like'ı güncellemelisiniz" }, status: :unprocessable_entity
        end
    end

    def is_logged_in
        if logged_in?
            # Chek if logged in
        end
    end

    def require_same_user
        if current_user.id != @details.user_id and !is_admin?
            render json: { message: "Like'ı düzenlemek veya silmek için yorumun kendinize ait olması gerekiyor" }, 
                            status: :unauthorized
        end
    end
end