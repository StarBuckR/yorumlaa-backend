class API::AdminsController < ApplicationController
    before_action :require_admin, only: [:approve, :list_not_approved]

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

    def render_not_admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end
end