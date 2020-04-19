class API::AdminsController < ApplicationController
    before_action :require_admin, only: [:approve, :list_not_approved, :create_rating_category]

    def approve
        product = Product.find(params[:id])

        if product && !product.approval
            product.update_attribute(:approval, true)
            render json: { message: "Ürün onaylandı", product: product }, status: :ok
        else
            render json: { message: "Ürün bulunamadı veya zaten onaylı" }, status: :unprocessable_entity
        end

    end

    def list_not_approved
        @products = Product.where(approval: false).all # onaylanmamış ürünleri getir
        render :show, status: :ok # onaylanmamış ürünleri ekrana bastır
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

    def render_not_admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end
end