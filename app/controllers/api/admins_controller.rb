class API::AdminsController < ApplicationController
    # before admin actions, check if user admin
    before_action :require_admin, only: [:approve, :list_not_approved, 
        :create_rating_category, :create_product_ratings, :create_category]
    
    before_action :ensure_product_exists, only: [:create_product_ratings]
    before_action :set_params, only: [:create_product_ratings] # set params before creating product ratingss
    #before_action :prevent_rating_duplicate, only: [:create_product_ratings] # prevent duplicate before creating product ratings
    before_action :category_params, only:[:create_category]
    before_action :prevent_category_duplication, only:[:create_category]

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
        if !RatingCategory.find_by(category_name: params[:category_name]) # if category name does not exists
            @category = RatingCategory.new(category_name: params[:category_name]) # create rating category
            if @category.save # if category is valid and saveable, render success message
                render json: { message: "Kategori başarı ile yaratıldı" }, status: :created
            else # if category isn't valid and not saved, render error messages
                render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
            end
        else # if category name exists, render error message
            render json: { message: "Bu isimde bir kategori zaten var" }, status: :unprocessable_entity
        end
    end

    def create_product_ratings
        if @product_rating.save # save product rating
            render json: @product_rating, status: :created # render product rating
        else # if cannot save, render error messages
            render json: { errors: @product_rating.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # create product category (electronics etc.) (create only category name)
    def create_category
        category = Category.new(category_params) # create category with credentials
        parent = params[:category][:parent]
        if parent # if parent attribute is filled, set parent
            category.parent = Category.find_by(name: parent)
            if !category.parent # if parent doesn't exist, render message and return
                render json: { message: "Parent kategori bulunamadı!" }, status: :unprocessable_entity and return
            end
        end

        if category.save # check if category is valid
            render json: category, status: :created
        else # if not valid, render error messages
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def display_category_tree
        tree = Category.all.arrange_serializable # find all categories and tre

        render json: tree.as_json
    end

    def render_not_admin # render that user is not admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end

    private
    def category_params
        params.require(:category).permit(:name)
    end

    def prevent_category_duplication
        if Category.find_by(category_params)
            render json: { message: "Bu kategori hali hazırda var" }, status: :unprocessable_entity
        end
    end

    def ensure_product_exists
        if !Product.find_by(id: params[:product_id])
            render json: { message: "Ürün bulunamadı" }, status: :unprocessable_entity
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