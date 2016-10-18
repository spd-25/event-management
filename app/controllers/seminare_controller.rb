class SeminareController < ApplicationController

  layout 'external'

  def index
    @categories = Category.cat_parents.order(:number)
    category_id = params[:category_id]
    @category = if category_id
      Category.find category_id
    else
      Category.cat_parents.first
    end
    @seminars = @category ? @category.seminars : Seminar
    @seminars = @seminars.order('events.date').includes(:teachers, :events, :location).all
    @seminars_count = Category.seminars_count
  end

  def show
    @seminar = Seminar.find params[:id]
  end

  def search
    @query = params[:q]
    @seminars = Seminar.external_search @query
    render :index
  end
end
