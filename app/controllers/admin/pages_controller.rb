module Admin

  class PagesController < BaseController
    before_action :set_page, only: %i[show update destroy seminars]

    def index
      authorize Page
      @pages = Page.order(:slug).all
    end

    def new
      authorize Page
      @page = Page.new
    end

    def show
    end

    def create
      authorize Page
      @page = Page.new page_params

      if @page.save
        redirect_to admin_pages_url, notice: t(:created, model: Page.model_name.human)
      else
        render :new
      end
    end

    def update
      if @page.update page_params
        redirect_to admin_pages_url, notice: t(:updated, model: Page.model_name.human)
      else
        render :show
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_url, notice: t(:destroyed, model: Page.model_name.human)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find params[:id]
      authorize @page
    end

    # Only allow a trusted parameter "white list" through.
    def page_params
      params.require(:page).permit(:title, :slug, :published, :content, :teaser)
    end
  end
end
