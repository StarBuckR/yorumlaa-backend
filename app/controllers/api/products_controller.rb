class API::ProductsController < ApplicationController
    before_action :ensure_category_exists, only: [:create]
    before_action :require_login, only: [:create]

    def show
        @product = Product.friendly.find(params[:id]) # get product from slug or id
        @comments = Comment.where(product_id: @product.id).all #get all comments under that product
        @comment_liked = []
        @ratings = average_ratings(@product.id)
        @all_ratings = Rating.where(product_id: @product.id).all
        @following = false
        if user_logged_in?
            is_following = Following.where(user_id: current_user.id).where(product_id: @product.id).first
            if is_following
                @following = true
            end
            @comments.each do |comment|
                like = UserCommentDetail.where(user_id: current_user.id).where(comment_id: comment.id).first
                if like
                    if like.like
                        @comment_liked.push("liked")
                    else
                        @comment_liked.push("disliked")
                    end
                else
                    @comment_liked.push(" ")
                end
            end
        end
        
        render :show, status: :ok # render product page
    end

    def create
        product = Product.new(product_params) # create new product with params under product_params
        
        if product.valid? && product.images.attached? && product.save # if product is valid and saved
            render json: product, status: :created # render the product
        else # if not valid
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity # render errors
        end
    end

    def search
        products = Product.search(params[:search])
        if products
            render json: products, status: :ok
        else
            render json: { errors: products.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def search_by_category
        category = params[:category]
        if category
            @products = Product.category_search(category)
            @ratings = []
            @products.each do |product|
                @ratings.push(average_ratings(product.id))
            end
            render :category, status: :ok
        else
            render json: { message: "Kategori bulunamadı!" }, status: :unprocessable_entity
        end
    end

    def average_ratings(product_id)
        all_ratings = Hash.new()

        product_ratings = Rating.where(product_id: product_id).all.pluck(:ratings)
        product_ratings.each do |ratings|
            ratings.each do |rating|
                all_ratings.merge!("#{rating["category_name"]}": rating["rating_value"]){ |k, a_value, b_value| (a_value + b_value).to_f / 2.to_f }
            end
        end

        return all_ratings
    end

    private

    def product_params
        params.require(:product).permit(:title, :category, images:[]) # permit title under product object
    end

    def ensure_category_exists
        if !Category.find_by(name: params[:product][:category]) #if category does not exist, render message an return
            render json: { message: "Kategori bulunamadı" }, status: :unprocessable_entity and return
        end
    end
end