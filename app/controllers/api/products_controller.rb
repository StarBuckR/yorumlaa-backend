class API::ProductsController < ApplicationController
    def show
        @product = Product.friendly.find(params[:id])
        @comments = Comment.where(product_id: @product.id).all
        render :show, status: :ok
    end

    def create
        if logged_in?
            product = Product.new(product_params)
            if product.valid? && product.save
                render json: product, status: :created
            else
                render json: { errors: product.errors.full_messages }, status: 401
            end
        end
    end

    private

    def product_params
        params.require(:product).permit(:title)
    end
end