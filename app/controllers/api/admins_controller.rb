class API::AdminsController < ApplicationController
    def approve
        product = Product.find(params[:id])
        is_admin = is_admin? # eğer admin değilse en başta hata vermesi için bir fonksiyon
        # is_admin= fonksiyonu içeride exception handling ile tokeni kontrol ediyor

        if product && !product.approval
            if is_admin
                product.update_attribute(:approval, true)
                render json: { message: "Ürün onaylandı", product: product }, status: :ok
            else
                render_not_admin # yetkili olman gerektiği mesajını döndürüyor
            end
        else
            render json: { message: "Ürün bulunamadı veya zaten onaylı" }, status: :unprocessable_entity
        end

    end

    def list_not_approved
        if is_admin?
            @products = Product.where(approval: false).all # onaylanmamış ürünleri getir
            render :show, status: :ok # onaylanmamış ürünleri ekrana bastır
        else
            render_not_admin # yetkili olman gerektiği mesajını döndürüyor
        end
    end

    def render_not_admin
        render json: { message: "Bu işlemi gerçekleştirmek için yetkili olmanız gerekiyor" },
                                status: :unauthorized
    end
end