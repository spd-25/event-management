class SeminareController < ApplicationController

  layout 'external'

  def index
    @categories = current_catalog.categories.roots.includes(children: { children: :children })
    category_id = params[:category_id]
    @category   = category_id ? current_catalog.categories.find(category_id) : @categories.first
    @seminars   = @category ? @category.seminars : current_catalog.seminars
    @seminars   = @seminars.published.order('events.date').includes(:teachers, :events, :location).all
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
