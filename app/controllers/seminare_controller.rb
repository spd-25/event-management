class SeminareController < ApplicationController

  layout 'external'

  def index
    @categories = Category.cat_parents.order(:number)
    category_id = params[:category_id]
    @category   = category_id ? Category.find(category_id) : Category.cat_parents.first
    @seminars   = @category ? @category.seminars : Seminar
    @seminars   = @seminars.published.order('events.date').includes(:teachers, :events, :location).all
    # @seminars = @seminars.order(:number).includes(:teachers, :events, :location).all
  end

  def show
    @seminar = Seminar.published.find params[:id]
  end

  def search
    @query = params[:q]
    @seminars = Seminar.published.external_search @query
    render :index
  end
end
