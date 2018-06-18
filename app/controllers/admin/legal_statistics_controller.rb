module Admin
  class LegalStatisticsController < BaseController

    def index
      authorize LegalStatistic
      @seminars = current_catalog.seminars.where(canceled: false).order(:number).includes(:legal_statistic).page(params[:page])
      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def show
      session[:back_path] = request.referer
      @statistic = LegalStatistic.find params[:id]
      @seminar = @statistic.seminar
      @statistic.fill_defaults
      authorize @statistic
    end

    def update
      @statistic = LegalStatistic.find params[:id]
      authorize @statistic
      if @statistic.update statistic_params
        redirect_to session[:back_path], notice: 'Statistikdaten gespeichert.'
      else
        render :show
      end
    end

    private

    # Only allow a trusted parameter "white list" through.
    def statistic_params
      params.require(:legal_statistic).permit LegalStatistic.column_names
    end

  end
end
