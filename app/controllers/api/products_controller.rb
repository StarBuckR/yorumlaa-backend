class API::ProductsController < ApplicationController
    before_action :ensure_category_exists, only: [:create]
    before_action :require_login, only: [:create]

    def show
        @product = Product.friendly.find(params[:id]) # get product from slug or id
        @comments = Comment.where(product_id: @product.id).all #get all comments under that product
        render :show, status: :ok # render product page
    end

    def create
        product = Product.new(product_params) # create new product with params under product_params
        
        if product.valid? && product.images.attached? && product.save # if product is valid and saved
            render json: product, status: :created # render the product
        else # if not valid
            render json: { errors: product.errors.full_messages }, status: :unprocessable_entity # render errors
        end
        byebug
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