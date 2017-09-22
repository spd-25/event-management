class SeminareController < ApplicationController

  layout 'external'

  def index
    @year            = params[:year].to_i
    @published_years = Catalog.published.pluck :year
    redirect_to(seminare_visitor_path(year: @published_years.first)) and return unless @year.in?(@published_years)
    @catalog  = Catalog.find_by(year: @year)
    @category = @catalog.categories.find_by(id: params[:category_id]) || @catalog.categories.roots.first
    @seminars = @category ? @category.all_seminars : Seminar
    # @seminars = @seminars.page(params[:page])
  end

  def show
    seminar_scope = Seminar
    seminar_scope = seminar_scope.published unless current_user&.admin?
    @seminar      = seminar_scope.find(params[:id]).decorate
  end

  def search
    @query = params[:q]
    @seminars = Seminar.published.external_search @query
    render :index
  end
end
