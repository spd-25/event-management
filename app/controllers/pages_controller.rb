class PagesController < ApplicationController

  def home
    @current_seminars = Seminar.published.where('date > NOW()').order(:date).limit(8)
  end

  def show
    slug = [params[:path1], params[:path2], params[:path3]].select(&:present?).join('/')
    static_page = "pages/static/#{slug}"
    return render static_page if lookup_context.find_all(static_page).any?

    @page = Page.published.find_by! slug: slug
  end
end
