class PagesController < ApplicationController

  def home; end

  def show
    @page = Page.find_by slug: params[:id]
  end
end
