class API::CommentsController < ApplicationController
    before_action :set_product_id, only: [:create, :update, :destroy, :update_rating] # set product id before these funcs
    before_action :set_comment, only: [:update, :destroy, :update_rating] # set comment before these func
    before_action :require_same_user, only: [:update, :destroy, :update_rating] # require same user for update destroy and uddate rating
    before_action :creating_controls, only: [:create] # control credentials before creating comment
    before_action :create_comment, only: [:create] # create comment

    before_action :create_rating, only: [:create] # create rating
    before_action :set_rating, only: [:update_rating, :destroy] # set rating before updating or destroying
    before_action :control_ratings, only: [:update_rating] # control credentials before updating rating

    def show
        @comments = Comment.joins("JOIN ratings ON comments.user_id = ratings.user_id").where(user_id: User.find_by(id: params[:id])).all # find users all comments
        @ratings = Rating.where(user_id: User.find_by(id: params[:id])).all
        
        if !User.find_by(id: params[:id]) # if user is not exists, render not exists
            render json: { message: "Kullanıcı bulunamadı!" }, status: :unprocessable_entity and return
        end
        render :show, status: :ok # show users all comments
    end

    def create
        if !(@created_comment.valid? && @created_rating.valid?) # if comment or  rating is not valid
            render json: { errors: @created_comment.errors.full_messages + @created_rating.errors.full_messages},
                            status: :unprocessable_entity and return
            # return error messages
        end

        if @created_comment.save && @created_rating.save # if created and saved
            render json: { comment: @created_comment, rating: @created_rating }, status: :created # render comment and rating
        end
    end

    def update
        @comment.update(body: params[:body]) # update the body with new param
        if @comment.save # if we can save the body
            render json: @comment, status: :ok # render comment
        else # if not
            render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity # render errors
        end
    end

    def update_rating
        @rating.update(ratings: params[:ratings]) # update rating param

        if @rating.save # save rating to database
            render json: @rating, status: :ok # render rating
        else # if not saved
            render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end # render errors
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

            @rating.delete
            @comment.delete
            render json: { message: "Yorum başarı ile silindi" }, status: :unprocessable_entity
            
        else
            render json: { message: "Yorum bulunamadı" }, status: :unprocessable_entity
        end
    end

    private
    def comment_params
        params.permit(:body) # permit body param
    end

    def creating_controls
        comment = Comment.where(product_id: @product_id) # find comment by product id
        if !@product_id # if product id is not found render not found
            render json: { message: "Ürün ID'si gerekiyor" }, status: :unprocessable_entity
        elsif comment.find_by(user_id: current_user.id) # if already have comment, render already have comment
            render json: { message: "Zaten bir yorumunuz bulunuyor" }, status: :unprocessable_entity
        end
    end

    def create_comment
        @created_comment = Comment.new(comment_params) # create new comment with params
        @created_comment.username = current_user.username # username of userdecoded by token
        @created_comment.user_id = current_user.id # id of user decoded by token
        @created_comment.product_id = @product_id # set product id
    end

    def control_ratings 
        product_categories = ProductRating.where(product_id: @product_id).first.category_names
        # find all categories that product has

        params[:ratings].each do |rating| # loop through all ratings and control 2 things
            # 1- if category is not matching the product categories, render that
            if !product_categories.include? rating[:category_name]
                render json: { message: "Kategorileri doğru girdiğinizden emin olun" },
                                status: :unprocessable_entity and return
            end
            # 2- if rating value is not between 0 and 10, render that
            if rating[:rating_value] < 0 || rating[:rating_value] > 10
                render json: { message: "Derecelendirmeler 0 ile 10 arasında olmalıdır" }, 
                                status: :unprocessable_entity and return
            end
        end
        # if received category size is not matching the product category size, render that
        if product_categories.size != params[:ratings].size
            render json: { message: "Kategorileri doğru girdiğinizden emin olun!" }, 
                        status: :unprocessable_entity and return
        end
    end

    def create_rating
        if Rating.find_by(product_id: @product_id, user_id: current_user.id) 
            # if you have rating already, render you already have rating
            render json: { message: "Zaten bir derecelendirmeniz bulunuyor"}, 
                            status: :unprocessable_entity
        end

        @created_rating = Rating.new(product_id: @product_id, user_id: current_user.id)
        # crate rating with product id and user id

        product_categories = ProductRating.where(product_id: @product_id).first.category_names
        # find all category names
        ratings = params[:ratings] # rating equals to received param ratings
        control_ratings # control ratings function

        @created_rating.ratings = ratings # ratings equals to created rating's ratings parameter 
    end

    def set_comment
        @comment = Comment.where(product_id: @product_id, user_id: current_user.id).first # find users comment under product
        
        if !@comment # if comment is not exists
            render json: { message: "Bu ürüne ait bir yorumunuz bulunmuyor" }, status: :unprocessable_entity and return
        end # render message and return
    end

    def set_rating
        @rating = Rating.where(product_id: @product_id, user_id: current_user.id).first # set rating by product and user id
    end

    def set_product_id
        @product_id = Product.friendly.find_by(slug: params[:slug]).id # find product id by slug
    end

    def require_same_user
        # if comment is not exists or user id and comment id doesn't match or user is not admin
        # render error you can only edit your own comment
        if !@comment and current_user.id != @comment.user_id and !is_admin?
            render json: { message: "Yorumu düzenlemek veya silmek için yorumun kendinize ait olması gerekiyor" }, 
                            status: :unauthorized
        end
    end
end