class API::ProductsController < ApplicationController
    def show
        @product = Product.friendly.find(params[:id])
        render json: @product, status: :ok
    end

    def create
        if logged_in?
            product = Product.new(product_params)
            if product.valid? && product.save
                render json: product, status: :created
            else
                render json: { errors: product.errors.full_messages }, status: 401
            end
        else
            render_not_logged_in # giriş yapman gerektiği mesajını döndürüyor
        end
    end

    private

    def product_params
        params.require(:product).permit(:title)
    end
end