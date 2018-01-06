class PagesController < ApplicationController

  layout 'external'

  def home
    # @page = Page.find_by slug: 'home'
  end

  def show
    # @page = Page.find_by slug: params[:id]
  end

end
