class VisitorsController < ApplicationController

  # layout 'old_site'
  layout 'external'

  def index
    if user_signed_in?
      redirect_to seminars_url
    else
      @categories = Category.cat_parents.order(:number)
      category_id = params[:category_id]
      @category = if category_id
        Category.find category_id
      else
        # @seminars = Seminar.order(:number).includes(:teachers, :events, :location).all
        Category.cat_parents.first
      end
      @seminars = @category ? @category.all_seminars : Seminar
      @seminars = @seminars.order('events.date').includes(:teachers, :events, :location).all
    end
  end

  def show
    @seminar = Seminar.find params[:id]
  end

  def search
    @query = params[:q]
    @seminars = PgSearch.multisearch(@query).where(searchable_type: 'Seminar').to_a.map(&:searchable)
    render :index
  end
end
