class PagesController < ApplicationController

  layout 'external', only: %i[home show]
  
  before_action :authenticate_user!, except: %i[home show]
  after_action :verify_authorized
  before_action :set_page, only: %i[edit update destroy]

  def index
    authorize Page
    @pages = Page.order(:title).all
  end

  def new
    authorize Page
    @page = Page.new
  end

  def home
    authorize Page
  end

  def show
    @page = Page.find_by slug: params[:id]
    authorize @page
  end

  def create
    authorize Page
    @page = Page.new page_params

    if @page.save
      redirect_to pages_url, notice: t(:created, model: Page.model_name.human)
    else
      render :new
    end
  end

  def edit

  end

  def update
    if @page.update page_params
      redirect_to pages_url, notice: t(:updated, model: Page.model_name.human)
    else
      render :show
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_url, notice: t(:destroyed, model: Page.model_name.human)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find params[:id]
    authorize @page
  end

  # Only allow a trusted parameter "white list" through.
  def page_params
    params.require(:page).permit(:title, :teaser, :content)
  end
end
