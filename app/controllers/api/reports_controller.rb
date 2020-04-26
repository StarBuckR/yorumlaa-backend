class API::ReportsController < ApplicationController
    before_action :require_admin, only:[:destroy]
    before_action :require_login, only:[:create]
    before_action :prevent_duplicate_report, only:[:create]

    def create
        report = Report.new(user_id: current_user.id, comment_id: params[:id], report_body: params[:report_body])

        if report.save
            render json: report, status: :created
        else
            render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        report = Report.find_by(id: params[:id])
        
        if report
            report.delete
            render json: { message: "Rapor başarı ile silindi" }, status: :ok
        else
            render json: { message: "Rapor bulunamadı" }, status: :unprocessable_entity
        end
    end

    private
    def prevent_duplicate_report
        if Report.where(user_id: current_user, comment_id: params[:id]).first
            render json: { message: "Zaten bir raporunuz bulunuyor" }, 
                            status: :unprocessable_entity and return
        end
    end
end