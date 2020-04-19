class API::CommentsController < ApplicationController
    before_action :set_product_id, only: [:create, :update, :destroy, :update_rating]
    before_action :set_comment, only: [:update, :destroy, :update_rating]
    before_action :require_same_user, only: [:update, :destroy, :update_rating]
    before_action :creating_controls, only: [:create]
    before_action :create_comment, only: [:create]

    before_action :create_rating, only: [:create]
    before_action :set_rating, only: [:update_rating]

    def show
        @comments = Comment.where(user_id: User.find_by(id: params[:id])).all
        render :show, status: :ok
    end

    def create
        if !(@created_comment.valid? && @created_rating.valid?)
            render json: { comment_errors: @created_comment.errors.full_messages,
                            rating_error: @created_rating.errors.full_messages},
                            status: :unprocessable_entity and return
        end

        if @created_comment.save && @created_rating.save
            render json: { comment: @created_comment, rating: @created_rating }, status: :created
        end
    end

    def update
        @comment.update(body: params[:body])
        if @comment.save
            render json: @comment, status: :ok
        else
            render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update_rating
        byebug
        @rating.update(category_name: params[:rating_category_name], 
            rating_value: params[:rating_value])

        if @rating.save
            render json: @rating, status: :ok
        else
            render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        if @comment
            dets = UserCommentDetail.where(comment_id: @comment.id).all
            dets.each do |detail| # delete all details (like and dislikes) from database
                if detail.like
                    Comment.find_by(id: @comment.id).decrement!(:like)
                else
                    Comment.find_by(id: @comment.id).decrement!(:dislike)
                end

                detail.delete
            end

            rating = Rating.find_by(product_id: @product_id)
            rating.delete

            @comment.delete
            render json: { message: "Yorum başarı ile silindi" }, status: :unprocessable_entity
            
        else
            render json: { message: "Yorum bulunamadı" }, status: :unprocessable_entity
        end
    end

    private
    def comment_params
        params.permit(:body)
    end

    def rating_params
        params.permit(:rating_value)
    end

    def creating_controls
        comment = Comment.where(product_id: @product_id)
        if !@product_id
            render json: { message: "Ürün ID'si gerekiyor" }, status: :unprocessable_entity
        elsif comment.find_by(user_id: current_user.id)
            render json: { message: "Zaten bir yorumunuz bulunuyor" }, status: :unprocessable_entity
        end
    end

    def create_comment
        @created_comment = Comment.new(comment_params)
        @created_comment.username = current_user.username # tokenle gelen kullanıcının username'i
        @created_comment.user_id = current_user.id # tokenle gelen kullanıcının ID'si
        @created_comment.product_id = @product_id
    end

    def create_rating
        @created_rating = Rating.new(rating_params)
        @created_rating.user_id = current_user.id
        @created_rating.product_id = @product_id

        categories = Rating.where(product_id: @product_id).all
        category = RatingCategory.find_by(category_name: params[:rating_category_name])
        @created_rating.product_category_id = category.id
    end

    def set_comment
        @comment = Comment.where(product_id: @product_id, user_id: current_user.id)
    end

    def set_rating
        @ratings = Rating.where(product_id: @product_id, user_id: current_user.id).all
    end

    def set_product_id
        @product_id = Product.friendly.find_by(slug: params[:slug]).id
    end

    def require_same_user
        if current_user.id != @comment.user_id and !is_admin?
            render json: { message: "Yorumu düzenlemek veya silmek için yorumun kendinize ait olması gerekiyor" }, 
                            status: :unauthorized
        end
    end
end