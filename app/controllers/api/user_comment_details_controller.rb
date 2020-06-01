class API::UserCommentDetailsController < ApplicationController
    before_action :set_comment # set comment before all actions
    before_action :is_logged_in, only: [:create, :update] # check if user logged in for create and update func
    before_action :set_details, only: [:update, :destroy] # set details before saving them for update and destroy func
    before_action :require_same_user, only: [:update, :destroy] # require same user for update and destroy func
    before_action :create_controls, only:[:create] # control credentials for create func
    before_action :prevent_duplication, only: [:create] # prevent duplicate likes

    #def index
    #    render json: { message: "Deneme" }, status: :ok
    #end

    # like or dislike comment
    def create
        details = UserCommentDetail.new(details_params) # create new user comment detail (like)
        details.comment_id = @comment.id # comment_id equals id coming with url "/api/comments/7"
        details.user_id = current_user.id # user_id of details is current user's id

        if details.save # if can save
            render json: details, status: :created # render details
        else # if not
            render json: { errors: details.errors.full_messages }, status: :unprocessable_entity and return # render errors
        end

        if(params[:details][:like]) # if it's a like increment like count on comment
            @comment.increment!(:like)
        else # if it's a increment dislike count on comment
            @comment.increment!(:dislike)
        end
    end

    #update like
    def update
        previous = UserCommentDetail.find_by(id: @details.id).like # find previous like (true or false)
        like = params[:details][:like] # current like equals parameter coming with method
        if previous == like # if previous and current like is equal (nothing is changed) render and return
            render json: { message: "Detayı değiştirmeniz gerekiyor" }, status: :unprocessable_entity and return
        end

        if @details.update(like: like) # if can, update the like with new parameter
            render json: @details, status: :ok # render detail
        else # if can not update, render errors
            render json: { errors: @details.errors.full_messages }, status: :unprocessable_entity
        end

        if previous # if previous is like decrement like
            @comment.decrement!(:like)
        else # if previous is dislike decrement like
            @comment.decrement!(:dislike)
        end

        if like # if current  is like, then increment like
            @comment.increment!(:like)
        else # if current is dislike, then increment dislike
            @comment.increment!(:dislike)
        end
    end

    # revoke like or dislike
    def destroy
        if @details.like # if
            @comment.decrement!(:like) # if previous was like, decrement like
        else
            @comment.decrement!(:dislike) # if previous was dislike, decrement like
        end

        @details.delete # delete comment detail and render success message
        render json: { message: "Detay başarı ile silindi" }, status: :ok
    end

    private
    def details_params
        params.require(:details).permit(:like) # permit like under details object
    end

    def set_comment
        @comment = Comment.find_by(id: params[:id])
        if !@comment # if comment is not exist, render error and return
           render json: { message: "Yorum bulunamadı" }, status: :unprocessable_entity and return
        end
    end

    def set_details
        @details = UserCommentDetail.find_by(user_id: current_user.id, comment_id: @comment.id) # find details by user and comment id
        if !@details # if detail is not exist, render not exists and return
            render json: { message: "Yoruma ait detay bulunamadı" }, status: :unprocessable_entity and return
        end
    end

    def create_controls
        details = UserCommentDetail.find_by(user_id: current_user.id) # find detail by user id
        if details && details.comment_id == @comment.id # if detail's comment id is equals to current comments id 
            render json: { message: "Yeniden like oluşturamazsınız, like'ı güncellemelisiniz" }, # display error and return
                status: :unprocessable_entity and return
        end
    end

    def prevent_duplication
        set_comment
        if UserCommentDetail.where(user_id: current_user.id).where(comment_id: @comment.id)
            render json: { message: "Zaten bir like bulunuyor" }, status: :unprocessable_entity and return
        end
    end

    def is_logged_in
        if logged_in?
            #
        end
    end

    def require_same_user
        if current_user.id != @details.user_id and !is_admin? # if current user's id is not equals to detail's user id
            # or user is not admin, display error and return
            render json: { message: "Like'ı düzenlemek veya silmek için yorumun kendinize ait olması gerekiyor" }, 
                            status: :unauthorized and return
        end
    end
end