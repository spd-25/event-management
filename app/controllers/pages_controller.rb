class PagesController < ApplicationController

  def home
    @current_seminars = Seminar.published.where('date > NOW()').order(:date).limit(8)
  end

  def show
    @page = Page.find_by slug: params[:id]
  end
end
