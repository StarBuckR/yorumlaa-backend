class API::ReportsController < ApplicationController
    before_action :require_admin, only:[:destroy]
    before_action :require_login, only:[:create]
    before_action :prevent_duplicate_report, only:[:create]

    # create new report for comment
    def create
        # create new report with given parameters
        report = Report.new(user_id: current_user.id, comment_id: params[:id], report_body: params[:report_body])

        if report.save # if report is valid and saveable, save and render report
            render json: report, status: :created
        else # if report isn't valid, render error messages
            render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
    end

    # destroy report
    def destroy
        report = Report.find_by(id: params[:id]) # find report by report id
        
        if report # if it exists, delete it and render success message
            report.delete
            render json: { message: "Rapor başarı ile silindi" }, status: :ok
        else # if not, render error message
            render json: { message: "Rapor bulunamadı" }, status: :unprocessable_entity
        end
    end

    private
    # prevent report duplicate
    def prevent_duplicate_report
        if Report.where(user_id: current_user, comment_id: params[:id]).first
            render json: { message: "Zaten bir raporunuz bulunuyor" }, 
                            status: :unprocessable_entity and return
        end
    end
end