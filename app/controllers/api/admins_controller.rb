class API::AdminsController < ApplicationController
    before_action :require_admin, only: [:approve, :list_not_approved, 
        :create_rating_category, :create_product_ratings]
    # before admin actions, check if user admin
    before_action :set_params, only: [:create_product_ratings] # set params before creating product ratingss
    before_action :prevent_duplicate, only: [:create_product_ratings] # prevent duplicate before creating product ratings

    def approve
        product = Product.find_by(id: params[:id]) # get product by id
        if product && !product.approval # check if product exists and not approved
            product.update(approval: true) # approve product
            render json: { message: "Ürün onaylandı", product: product }, status: :ok # render message and product
        else # if not
            render json: { message: "Ürün bulunamadı veya zaten onaylı" }, status: :unprocessable_entity
        end # render product not found or already approved

    end

    def list_not_approved
        @products = Product.where(approval: false).all # fetch all not approved products
        render :show, status: :ok # render all not approved products
    end

    def create_rating_category
        if !RatingCategory.find_by(category_name: params[:category_name])
            @category = RatingCategory.new(category_name: params[:category_name])
            if @category.save
                render json: { message: "Kategori başarı ile yaratıldı" }, status: :created
            else
                render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { message: "Bu isimde bir kategori zaten var" }, status: :unprocessable_entity
        end
    end

    def create_product_ratings
        if @product_rating.save
            render json: @product_rating, status: :created
        else
            render json: { errors: @product_rating.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def render_not_admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end

    private
    def prevent_duplicate
        if ProductRating.find_by(product_id: params[:product_id])
            render json: { message: "Zaten bir product rating bulunuyor" }, 
                        status: :unprocessable_entity
        end
    end

    def set_params
        @product_rating = ProductRating.new(product_id: params[:product_id])
        ratings = params[:ratings]
        category_names = []

        ratings.each do |rating|
            if !RatingCategory.find_by(category_name: rating[:category_name])
                render json: { message: "Kategori bulunamadı: " + rating[:category_name] }, status: :unprocessable_entity
            end

            category_names.push(rating[:category_name])
        end

        @product_rating.category_names = category_names
    end
end