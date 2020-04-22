class API::ProductsController < ApplicationController
    def show
        @product = Product.friendly.find(params[:id]) # get product from slug or id
        @comments = Comment.where(product_id: @product.id).all #get all comments under that product
        render :show, status: :ok # render product page
    end

    def create
        if logged_in? # if user is logged in
            product = Product.new(product_params) # create new product with params under product_params
            if product.valid? && product.save # if product is valid and saved
                render json: product, status: :created # render the product
            else # if not valid
                render json: { errors: product.errors.full_messages }, status: 401 # render errors
            end
        end
    end

    private

    def product_params
        params.require(:product).permit(:title) # permit title under product object
    end
end