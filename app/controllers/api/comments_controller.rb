class API::CommentsController < ApplicationController
    before_action :set_product_id, only: [:create, :update, :destroy]
    before_action :set_comment, only: [:update, :destroy]
    before_action :require_same_user, only: [:update, :destroy]
    before_action :creating_controls, only: [:create]
    before_action :create_comment, only: [:create]

    def show
        @comments = Comment.where(user_id: User.find_by(id: params[:id])).all
        render :show, status: :ok
    end

    def create
        if @created_comment.save
            render json: @created_comment, status: :created
        else
            render json: { errors: @created_comment.errors.full_messages }, status: :unprocessable_entity
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

    def destroy
        if @comment
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

    def set_comment
        comments = Comment.where(product_id: @product_id)
        @comment = comments.find_by(user_id: current_user.id)
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