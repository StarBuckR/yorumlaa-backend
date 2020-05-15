class API::AdminsController < ApplicationController
    # before admin actions, check if user admin
    before_action :require_admin, only: [:approve, :list_not_approved, 
        :create_rating_category, :create_product_ratings, :create_category,
        :create_category_tree, :delete_category_tree, :create_whole_category_tree]

    before_action :set_params, only: [:create_product_ratings] # set params before creating product ratingss
    #before_action :prevent_rating_duplicate, only: [:create_product_ratings] # prevent duplicate before creating product ratings
    before_action :category_params, only:[:create_category_tree]
    before_action :ensure_category_exists, only:[:create_category_tree]
    before_action :prevent_duplicate_category_tree, only:[:create_category_tree]

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
        # create category by name
        category = CategoryName.new(category_name: params[:category_name])
        if category.save # check if category is valid
            render json: category, status: :created
        else # if not valid, render error messages
            render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # create category tree
    def create_category_tree 
        category_tree =  CategoryTree.new(category_params)
        if category_tree.save
            render json: { message: category_tree }, status: :created
        else
            render json: { errors: category_tree.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def delete_category_tree
        category_tree = CategoryTree.find_by(category_params)
        if category_tree
            category_tree.delete
            render json: { message: "Kategori ağacı başarı ile silindi!" }, status: :ok
        else
            render json: { message: "Kategori ağacı bulunamadı!" }, status: :unprocessable_entity
        end
    end

    def render_not_admin # render that user is not admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end

    def create_whole_category_tree 
        # i don't delete recent trees for future references
        
        categories = CategoryName.all
        tree = Hash.new()
        tree = arrayize_tree(categories)
        render json: tree
        
        #category_tree = WholeCategoryTree.new(tree: tree)
        return
        if category_tree.save
            render json: category_tree, status: :created
        else
            render json: { errors: category_tree.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    # def arrayize_tree(categories)
    #     all = TreeNode.new(categories.size)
        
    #     categories.each do |category|
    #         parent = category.category_name
    #         if !CategoryTree.find_by(current_category: parent)
    #             all.children << (recursive_children(parent))
    #             #all.merge!("#{parent}": recursive_children(parent).to_hash)
    #         end
    #     end

    #     return all
    # end

    # def recursive_children(parent)
    #     children = CategoryTree.where(parent_category: parent).pluck(:current_category)
        
    #     current_array = Tree.new(children.size)
    #     current_array.children << children

    #     children.each do |child|
    #         if CategoryTree.find_by(parent_category: child)
    #             current_array.children << (recursive_children(child))
    #         end
    #     end

    #     return current_array
    # end

    def category_params
        params.require(:category).permit(:current_category, :parent_category)
    end

    # this function ensures categories exists
    def ensure_category_exists
        params.require(:category).each do |category|
            if !CategoryName.find_by(category_name: category) # if can not find category, render error and return
                render json: { message: "Kategori bulunamadı: '#{category.at(1)}'" }, status: :unprocessable_entity and return
            end
        end
    end

    def prevent_duplicate_category_tree
        if CategoryTree.find_by(category_params)
            render json: { message: "Zaten bu şekilde bir kategori ağacı bulunuyor" }, status: :unprocessable_entity and return
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